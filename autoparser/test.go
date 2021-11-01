package main

import (
	//"fmt"
	"regexp"
	"fmt"
	. "fmt"
	"io/ioutil"
	"math/rand"
	"os"
	"path/filepath"
	"strings"
	"github.com/schollz/progressbar"
	"sort"


	"github.com/armon/go-radix"
	"github.com/tchap/go-patricia/patricia"
)

var (
	trie *patricia.Trie
	max  = 10
	tr   *radix.Tree
	rules map[string]int
	fileCache map[string]string
	tokCache map[string][]string
	maxFiles = int64(-1)
)

func Min(a, b int) int {
	if a > b {
		return b
	}
	return a
}

var ruleTree *RuleNode

func newNode() *RuleNode{
return &RuleNode{Patterns: map[string]*RuleNode{}, Count: map[string]int64{}}
}

func DumpRuleTree_r(r *RuleNode, prefix string){
	if r == nil {return}
	for k,v := range r.Patterns {
		Println(prefix,k, ":", r.Count[k])
		DumpRuleTree_r(v, prefix+" ")
	}
}
func DumpRuleTree(r *RuleNode){
	DumpRuleTree_r(r, "")
}
func main() {
	ruleTree = newNode()
	ruleTree.Patterns["START"]=nil
	tokCache = map[string][]string{}
	fileCache = map[string]string{}
	trie = patricia.NewTrie()
	tr = radix.New()
	rules = map[string]int{}
	rules[""]=51
	rules["a"]=51

	ext := os.Args[1]
	datapath := os.Args[2]


	mapFiles(datapath, ext, func(filepath, data string){
		toks := tokeniseGo(data)
		toks, rule_matched, end_node, success := applyRuleTree(ruleTree, ruleTree, toks, []string{})
		if success {
			if len(toks)>0 {
				fmt.Println("Matched", rule_matched, " but incomplete")
				candidates := map[string]int{}
				Println("Searching for candidates to expand rule", rule_matched)
				bar := progressbar.Default(maxFiles)
				maxFiles=-1
				mapFiles(datapath, ext, func(filepath, data string){
					maxFiles=maxFiles+1
					toks := loadTokens(filepath)
					toks_remaining, success := applyRule(rule_matched, toks)
					if success {
					if len(toks_remaining)>1 {
						bar.Add(1)
						//fmt.Println("Found candidates",candidates," for ", rule_matched, "in", filepath)
						candidates[toks_remaining[0]] = candidates[toks_remaining[0]]+1
				}}})
				
				ranked := rankByWordCount(candidates)
				fmt.Println("Found candidates",ranked," for ", rule_matched)
				n:=newNode()
				
				if len(ranked)>1 && ranked[0].Value>ranked[1].Value*2{
					Println("Token", ranked[0].Key,"is probably a structure token")
				}

				if len(ranked)>10 {
					n.Patterns["**"]=nil
					n.Count["**"]=-1
				}
				for x:=0;x<10 && x<len(ranked);x++ {
				//fmt.Println("Found candidate ",top," for ", rule_matched)
				
				n.Patterns[ranked[x].Key]=nil
				n.Count[ranked[x].Key]=int64(ranked[x].Value)
				
				
			}
			end_node.Patterns[rule_matched[len(rule_matched)-1]]=n
			DumpRuleTree( ruleTree)

			} else {
				fmt.Println("Matched", rule_matched)
			}
		} else {
			//fmt.Println("Unable to match any rules")
		}
	})
	//process_path(os.Args[2])

	

	printItem := func(prefix patricia.Prefix, item patricia.Item) error {
		count := interface{}(item).(int)
		if count > max {
			max = count
		}
		if count > 50 {
			fmt.Printf("%v: %q\n", item, prefix)
			
		}
		return nil
	}

	trie.Visit(printItem)

	pi := func(s string, v interface{}) bool {
		count := v.(int)
		if count > max {
			max = count
		}
		if count > 5 {
			fmt.Printf("%v: %q\n", v.(int), s)
		}
		return false
	}
	tr.Walk(pi)

}


func loadTokens(path string) []string {
	f,ok  := tokCache[path]
	if ok {
		return f
	}

	file := loadFile(path)
	toks := tokeniseGo(file)
	tokCache[path] = toks
	return toks
}

func loadFile(path string) string {
	f,ok  := fileCache[path]
	if ok {
		return f
	}

	fileb, _ := ioutil.ReadFile(path)
	file := string(fileb)
	fileCache[path] = file
	return file
}

func mapFiles(path string, extension string, userfunc func (datapath, data string)) {
	filepath.Walk(path, func(path string, info os.FileInfo, err error) error {

		//If it is inaccessible, return
		if err != nil {
			fmt.Printf("prevent panic by handling failure accessing a path %q: %v\n", path, err)
			return nil
		}
		//We don't care about dirs
		if info.IsDir() {
			return nil
		}
		//If we match the suffix, run the user func
		if strings.HasSuffix( path ,extension) {
			//Println("Ingesting", path)
			file := loadFile(path)
			userfunc(path, file)
		}
		return nil
	})
}

func process_path(path string) {
	err:=filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
		
		if err != nil {
			fmt.Printf("prevent panic by handling failure accessing a path %q: %v\n", path, err)
			return nil
		}
		if info.IsDir() {
			return nil
		}
		if strings.HasSuffix( path ,os.Args[1]) {
			Println("Ingesting", path)
			ingest(path)
		}
		return nil
	})
	if err != nil {
		fmt.Println(err)
	}
}

type RuleNode struct {
	Patterns map[string]*RuleNode
	Count map[string]int64
}


func applyRuleTree(ruleTree, prev *RuleNode, keys []string, currentrule []string) ([]string, []string, *RuleNode, bool) {
	//fmt.Println("Matching", rule, "with", keys)
	if ruleTree==nil {
		//fmt.Println("Rule succeeded")
		return keys,currentrule, prev,true //The rule succeeded
	}
	if len(keys) <1 {
		//fmt.Println("Rule failed")
		return nil,currentrule, ruleTree, false  //The rule ran past the end of the input
	}

	//Loop and match patterns
	for k,v := range ruleTree.Patterns {
		if k == keys[0]{
			//Match
			return applyRuleTree(v, ruleTree,keys[1:], append (currentrule, k))
		}
		
		if k=="**"{
			return applyRuleTree(v, ruleTree,keys[1:], append (currentrule, k))
		}
		if k=="***" {
			_, _,_,matchNext := applyRuleTree(v, ruleTree,keys[1:],append (currentrule, k))
			//fmt.Println("Wildcard")
			if matchNext {
				//fmt.Println("Matched wildcard terminator")
				return applyRuleTree(v, ruleTree,keys[1:],append (currentrule, k))
				
			} else {
				return applyRuleTree(ruleTree, ruleTree,keys[1:],append (currentrule, k))
			}
		}

	}
	//fmt.Println("Rule failed")
	return nil, currentrule, ruleTree, false
}


func applyRule(rule, keys []string) ([]string, bool) {
	//fmt.Println("Matching", rule, "with", keys)
	if len(rule)<1 {
		//fmt.Println("Rule succeeded")
		return keys, true //The rule succeeded
	}
	if len(keys) <1 {
		//fmt.Println("Rule failed")
		return nil, false  //The rule ran past the end of the input
	}
	if rule[0]=="***" {
		//fmt.Println("Wildcard")
		if rule[1] == keys [0] {
			//fmt.Println("Matched wildcard terminator")
			return applyRule(rule[1:], keys)
		} else {
			return applyRule(rule, keys[1:])
		}
	}
	if rule[0] == "**" {
		return applyRule(rule[1:], keys[1:])
	}
	if rule[0] == keys [0] {
		return applyRule(rule[1:], keys[1:])
	}
	//fmt.Println("Rule failed")
	return nil, false
}

func tokeniseGo(data string) []string {
	
	data = strings.ReplaceAll(data, "\n\n", "\n")
	data = strings.ReplaceAll(data, "\n", " NEWLINE ")
	data=regexp.MustCompile("//(.+?)NEWLINE").ReplaceAllString(data, "")
	data = strings.ReplaceAll(data, "\t", " ")
	data = strings.ReplaceAll(data, "\r", " ")

	data = strings.ReplaceAll(data, "  ", " ")
	data = strings.ReplaceAll(data, "  ", " ")
	data = strings.ReplaceAll(data, "  ", " ")
	keys := strings.Split("START "+data, " ")
	return keys
}

func ingest(path string) {
	// Create a new default trie (using the default parameter values).
	Println("Ingesting", path)
	fileb, _ := ioutil.ReadFile(path)
	file := string(fileb)
keys := tokeniseGo(file)
	//Println(keys)


	
	var tempKeys []string = keys
	for j:= 0; j<2 ; j++ {
	//fmt.Println("Rules:",rules)
	for rule,_ := range rules {
		rulebits := strings.Split(rule, " ")
		//fmt.Printf("Applying rule: %v\n", rulebits)
		remainder, success := applyRule(rulebits, keys)
		if success {
			
				rules[rule]=rules[rule]+1
		
			//fmt.Println("Rule Matched:", len(tempKeys)-len(remainder), "tokens")
			tempKeys = remainder
			
		}
		l := Min(len(tempKeys), 100)
	for i := 1; i < l-1; i = i + 1 {
		//m := Min(l, i+10)
		//for j := i; j < m; j = j + 1 {
		in := strings.Join(tempKeys[:i], " ") + " *** " + tempKeys[i+1] //+ strings.Join(tempKeys[j:], " ")
		//Println("* Importing", i, j, in)
		valitem := trie.Get(patricia.Prefix(in))
		val := 0
		if valitem == nil {
			val = 0
		} else {
			val = interface{}(valitem).(int)
		}
		//trie.Set(patricia.Prefix(in), val+1)

		vi, found := tr.Get(in)
		if !found {
			val = 0
		} else {
			val = vi.(int)
		}
		tr.Insert(in, val+1)
		if _,ok := rules[in]; !ok {
			rules[in]=1
		} 


		//}
	}
}
	}

	printItem := func(prefix patricia.Prefix, item patricia.Item) error {
		count := interface{}(item).(int)
		if count > max {
			max = count
		}
		if count > max/10 {
			fmt.Printf("%v: %q\n", item, prefix)
		}
		return nil
	}

	pi := func(s string, v interface{}) bool {
		count := v.(int)
		if count > max {
			max = count
		}
		if count > max/10 {
			fmt.Printf("%v: %q\n", v.(int), s)
		}
		return false
	}
	if rand.Float64() < 1.01 {
		if false {
		trie.Visit(printItem)
		tr.Walk(pi)
		}
		list := rankByWordCount(rules)
		for i:=0; i<100 && i<len(list);i++ {
			
				fmt.Printf("%v: %v\n", list[i].Value, list[i].Key)
		
	}
}

}


func rankByWordCount(wordFrequencies map[string]int) PairList{
	pl := make(PairList, len(wordFrequencies))
	i := 0
	for k, v := range wordFrequencies {
	  pl[i] = Pair{k, v}
	  i++
	}
	sort.Sort(sort.Reverse(pl))
	return pl
  }
  
  type Pair struct {
	Key string
	Value int
  }
  
  type PairList []Pair
  
  func (p PairList) Len() int { return len(p) }
  func (p PairList) Less(i, j int) bool { return p[i].Value < p[j].Value }
  func (p PairList) Swap(i, j int){ p[i], p[j] = p[j], p[i] }