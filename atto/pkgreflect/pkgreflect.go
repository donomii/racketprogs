/*
Problem: Go reflection does not support enumerating types, variables and functions of packages.

pkgreflect generates a file named pkgreflect.go in every parsed package directory.
This file contains the following maps of exported names to reflection types/values:

	var Types = map[string]reflect.Type{ ... }
	var Functions = map[string]reflect.Value{ ... }
	var Variables = map[string]reflect.Value{ ... }

Command line usage:

	pkgreflect --help
	pkgreflect [-notypes][-nofuncs][-novars][-unexported][-norecurs][-gofile=filename.go] [DIR_NAME]

If -norecurs is not set, then pkgreflect traverses recursively into sub-directories.
If no DIR_NAME is given, then the current directory is used as root.
*/
package main

import (
	"bytes"
	"flag"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"io"
	"io/fs"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/donomii/goof"
)

var (
	notypes    bool
	nofuncs    bool
	novars     bool
	noconsts   bool
	unexported bool
	norecurs   bool
	stdout     bool
	gofile     string
	notests    bool
)

func main() {
	flag.BoolVar(&notypes, "notypes", false, "Don't list package types")
	flag.BoolVar(&nofuncs, "nofuncs", false, "Don't list package functions")
	flag.BoolVar(&novars, "novars", false, "Don't list package variables")
	flag.BoolVar(&noconsts, "noconsts", false, "Don't list package consts")
	flag.BoolVar(&unexported, "unexported", false, "Also list unexported names")
	flag.BoolVar(&norecurs, "norecurs", false, "Don't parse sub-directories resursively")
	flag.StringVar(&gofile, "gofile", "pkgreflect.go", "Name of the generated .go file")
	flag.BoolVar(&stdout, "stdout", false, "Write to stdout.")
	flag.BoolVar(&notests, "notests", false, "Don't list test related code")
	flag.Parse()

	if len(flag.Args()) > 0 {
		for _, stuff := range flag.Args() {
			bits := strings.Split(stuff, ":")
			fullname, dir := bits[0], bits[1]
			oldDir, _ := os.Getwd()
			defer os.Chdir(oldDir)
			log.Println("Switching to", dir)
			os.Chdir(dir)
			parseDir(fullname, ".")
		}
	} else {
		parseDir("dunno", ".")
	}

	fmt.Print(`package atto
	import (
		"reflect"
		`)
	for pkg, alias := range i {
		fmt.Printf(`ns%v "%v"
`, alias, pkg)
	}

	fmt.Print(`
	)
	func Build() map[string]map[string]map[string]reflect.Value {

	var p = map[string]map[string]map[string]reflect.Value{}

	`)

	for pkg, a := range p {
		fmt.Printf(`p["%v"]=map[string]map[string]reflect.Value{}
		`, pkg)
		for typ, b := range a {
			fmt.Printf(`p["%v"]["%v"]=map[string]reflect.Value{}
			`, pkg, typ)
			for name, c := range b {
				fmt.Printf(`p["%v"]["%v"]["%v"]=%v
				`, pkg, typ, name, c)
			}
		}
	}

	fmt.Println(`return p
	}`)
	//fmt.Printf("combined: %+v", p)

}

var p = map[string]map[string]map[string]string{}
var i = map[string]int{}
var ns = 0

func parseDir(fullname, dir string) {
	fuck, _ := os.Getwd()
	log.Println("Loading", fullname, "from", fuck)
	foundPackage := false
	for _, v := range []string{"glfw", "registry", "honnef.co", "donomii/pbot", "donomii/atto", "sergi/go-diff", "go-gl", "golang.org/x/", "internal", ".git", "PaulSonOfLars", " ", "'", "\"", "%"} {
		if strings.Contains(dir, v) {
			return
		}
	}

	dirFile, err := os.Open(dir)
	if err != nil {
		panic(err)
	}
	defer dirFile.Close()
	info, err := dirFile.Stat()
	if err != nil {
		panic(err)
	}
	if !info.IsDir() {
		panic("Path is not a directory: " + dir)
	}

	pkgs, err := pparseDir(token.NewFileSet(), dir, filter, 0)
	if err != nil {
		log.Println(err)
		return
	}

	imp := strings.ReplaceAll(dir, "../", "")
	imp = strings.TrimPrefix(imp, "./")
	imp = strings.TrimSuffix(imp, "/")

	modver := goof.Shell("head -1 " + dir + "/go.mod | perl -pe 's/module //g;chomp'")
	if !strings.Contains(modver, "No such file or directory") && !strings.Contains(modver, "head: Error reading") && len(modver) > 4 {
		imp = modver
		log.Println("Found mod:", modver)
	}
	ns = ns + 1

	result := goof.Shell("go build .")
	if result != "" {

		for _, pkg := range pkgs {
			added := 0
			if pkg.Name == "main" {
				return
			}
			foundPackage = true

			var buf bytes.Buffer
			/*
				// Types
				if !notypes {
					added = added + print(&buf, pkg, ast.Typ, "reflect.TypeOf((*%s.%s)(nil)).Elem()")

				}
			*/

			// Functions
			if !nofuncs {
				added = added + print(&buf, pkg, ast.Fun, "reflect.ValueOf(%s.%s)")
			}

			/*
				if !novars {
					added = added + print(&buf, pkg, ast.Var, "reflect.ValueOf(&%s.%s)")
				}
			*/

			/*
				if !noconsts {
					added = added + print(&buf, pkg, ast.Con, "reflect.ValueOf(%s.%s)")
				}
			*/

			if added > 0 {
				i[fullname] = ns
			}

		}

		if foundPackage {
			return
		}
	}

	if !norecurs {
		dirs, err := dirFile.Readdir(-1)
		if err != nil {
			panic(err)
		}
		for _, info := range dirs {
			if info.IsDir() {
				parseDir(fullname, filepath.Join(dir, info.Name()))
			}
		}
	}
}

func print(w io.Writer, pkg *ast.Package, kind ast.ObjKind, format string) int {
	if pkg.Name == "main" {
		return 0
	}

	added := 0
	names := []string{}
	for _, f := range pkg.Files {
		for name, object := range f.Scope.Objects {
			skip := false
			for _, v := range []string{"Test", "Benchmark", "Example"} {
				if strings.Contains(name, v) {
					skip = true
				}
			}
			if !skip && (object.Kind == kind && (unexported || ast.IsExported(name))) {
				names = append(names, name)
			}
		}
	}
	sort.Strings(names)
	for _, name := range names {
		added = added + 1
		if _, ok := p[pkg.Name]; !ok {
			p[pkg.Name] = map[string]map[string]string{}
		}
		if _, ok := p[pkg.Name][fmt.Sprintf("%v", kind)]; !ok {
			p[pkg.Name][fmt.Sprintf("%v", kind)] = map[string]string{}
		}
		p[pkg.Name][fmt.Sprintf("%v", kind)][name] = fmt.Sprintf(format, fmt.Sprintf("ns%v", ns), name)
		fmt.Fprintf(w, format, name, pkg.Name, name)
	}
	return added
}

func filter(info os.FileInfo) bool {

	name := info.Name()

	if info.IsDir() {
		return false
	}

	if name == gofile {
		return false
	}

	if filepath.Ext(name) != ".go" {
		return false
	}

	if strings.HasSuffix(name, "_test.go") && notests {
		return false
	}

	return true

}

func pparseDir(fset *token.FileSet, path string, filter func(fs.FileInfo) bool, mode parser.Mode) (pkgs map[string]*ast.Package, first error) {
	list, err := os.ReadDir(path)
	if err != nil {
		return nil, err
	}

	pkgs = make(map[string]*ast.Package)
	for _, d := range list {
		if d.IsDir() || !strings.HasSuffix(d.Name(), ".go") {
			continue
		}
		if filter != nil {
			info, err := d.Info()
			if err != nil {
				return nil, err
			}
			if !filter(info) {
				continue
			}
		}
		filename := filepath.Join(path, d.Name())
		if strings.Contains(filename, "_") || strings.Contains(filename, "test") {
			continue
		}
		bin, _ := ioutil.ReadFile(filename)
		if bytes.Contains(bin, []byte("+build")) {
			continue
		}
		if src, err := parser.ParseFile(fset, filename, nil, mode); err == nil {
			name := src.Name.Name
			pkg, found := pkgs[name]
			if !found {
				pkg = &ast.Package{
					Name:  name,
					Files: make(map[string]*ast.File),
				}
				pkgs[name] = pkg
			}
			pkg.Files[filename] = src
		} else if first == nil {
			first = err
		}
	}

	return
}
