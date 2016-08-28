package goSym

import (
    "github.com/tchap/go-patricia/patricia"
    "log"
    _ "github.com/mattn/go-sqlite3"
    "database/sql"
    "time"
    "fmt"
    "bytes"
)


type symTable struct {
    reverse_string_table []string
    counters             map[string]int
    memory_db            bool
    debug                bool
    dbHandle             *sql.DB
    next_string_index    int
    string_table         *patricia.Trie
    symbol_cache         map[string]int
}

func (s *symTable) count(c string) {
    return
    s.counters[c]++
}

func New () *symTable {
    s := symTable{}
    return &s
}

func match_trie(string_table *patricia.Trie, key patricia.Prefix) bool {
	defer func() {
		if r := recover(); r != nil {
			log.Println("Error while matching string", r, ", retrying")
			time.Sleep(1 * time.Second)
			match_trie(string_table, key)
		}
	}()

	val := string_table.Match(key)

	return val
}


func read_trie(string_table *patricia.Trie, key patricia.Prefix) int {
	defer func() {
		if r := recover(); r != nil {
			log.Println("Error while reading string", r, ", retrying")
			time.Sleep(1 * time.Second)
			read_trie(string_table, key)
		}
	}()

	val := string_table.Get(key)
	if val == nil {
		log.Printf("Got nil for string table lookup (key:%v)", key)
		return 0
	}
	return val.(int)
}

func (s *symTable) GetString(index int) string {
	if s.memory_db {
		if s.debug {
			log.Println("Fetching string: ", index)
		}
		return s.reverse_string_table[index]
	}
    return ""
}

func (s *symTable) get_memdb_symbol(aStr string) (int, error) {
	if s.debug {
		log.Printf("string: %V\n", aStr)
	}

	if s == nil {
		panic("Symbol table is nil")
	}
	if s.dbHandle != nil {
		panic("dbhandle not nil for memdb!")
	}

	key := patricia.Prefix(aStr)
	if key == nil {
		log.Printf("Got nil for radix string lookup on '%v'", aStr)
		log.Printf("Number of tags: %v", s.next_string_index+1)
		return 0, fmt.Errorf("Key not found in radix tree")
	}
	defer func() {
		if r := recover(); r != nil {
			log.Println("Error while reading string", r, ", retrying")
			time.Sleep(1 * time.Second)
			read_trie(s.string_table, key)
		}
	}()
	var retval int
	retval = 0
	if match_trie(s.string_table, key) {
		val := s.string_table.Get(key)
		if val == nil {
			log.Printf("Got nil for string table lookup (key:%v)", key)
			log.Printf("Number of tags: %v", s.next_string_index+1)
			return 0, fmt.Errorf("String '%s' not found in tag database", aStr)
		}
		retval = val.(int)
	}

	return retval, nil
}

func (s *symTable) Lookup(aStr string) (int, error) {
	var retval int
	var err error
	if val, ok := s.symbol_cache[aStr]; ok {
		s.count("symbol_cache_hit")
		return val, nil
	} else {
		s.count("symbol_cache_miss")
		if s.memory_db {
			retval, err = s.get_memdb_symbol(aStr)
		} else {
			//retval, err = s.get_diskdb_symbol(aStr)

		}
		if retval != 0 && err == nil {
			s.symbol_cache[aStr] = retval
		}
	}
	return retval, err
}

//func (s *symTable) get_diskdb_symbol(aStr string) (int, error) {
	//var retval int
	//retval = 0
	//if debug {
		////log.Printf("Silo: %V\n", s)
		//log.Printf("string: %V\n", aStr)
	//}
	////log.Printf("Silo: %V, string: %V, db: %V\n", s, aStr, s.dbHandle)
	//if s == nil {
		//panic("Silo is nil")
	//}
	//if s.dbHandle == nil {
		//panic("nil dbhandle!")
	//}
	//if s.memory_db {
		//key := patricia.Prefix(aStr)
		//if key == nil {
			//log.Printf("Got nil for radix string lookup on '%v'", aStr)
			//log.Printf("Number of tags: %v", s.next_string_index+1)
			//return 0, fmt.Errorf("Key not found in radix tree")
		//}
		//defer func() {
			//if r := recover(); r != nil {
				//log.Println("Error while reading string", r, ", retrying")
				//time.Sleep(1 * time.Second)
				//read_trie(s.string_table, key)
			//}
		//}()
//
		//if match_trie(s.string_table, key) {
			//val := s.string_table.Get(key)
			//if val == nil {
				//log.Printf("Got nil for string table lookup (key:%v)", key)
				//log.Printf("Number of tags: %v", s.next_string_index+1)
				//return 0, fmt.Errorf("String '%s' not found in tag database", aStr)
			//}
			//retval = val.(int)
		//}

	//} else {

		//var res int
		//s.count("sql_select")

		//err := s.dbHandle.QueryRow("select value from SymbolTable where id like ?", bytes(aStr)).Scan(&res)
		//if err != nil {
			////s.LogChan["warning"] <- fmt.Sprintln("While trying to read  ", aStr, " from SymbolTable: ", err)
		//}

		//if err == nil {
			//retval = int(res)
		//} else {
			////log.Printf("Error retrieving symbol for '%v': %v", aStr, err)
		//}
	//}
	//return retval, nil
//}

func (s *symTable) LookupOrCreate(aStr string) int {
	for i := 0; s == nil; i = i + 1 {
		time.Sleep(time.Millisecond * 100)
	}
	if val, ok := s.symbol_cache[aStr]; ok {
		s.count("get/create_symbol_cache_hit")
		return val
	} else {
		s.count("get/create_symbol_cache_miss")
		if aStr == "" {
			log.Printf("Invalid insert!  Cannot insert empty string into symbol table")
			log.Printf("Number of tags: %v", s.next_string_index+1)
			return 0
		}

		val, _ := s.Lookup(aStr)
		if val != 0 {
			return val
		} else {
			if s.debug {
						log.Println("Attempting lock in get_or_create_symbol")
					}
					s.LockMe()
					defer func() {
						s.UnlockMe()
						if s.debug {
							log.Println("Released lock in get_or_create_symbol")
						}
					}()
					if s.debug {
						log.Println("Got lock in get_or_create_symbol")
					}
			val, _ := s.Lookup(aStr)
			if val != 0 {
				return val
			} else {
				s.next_string_index = s.next_string_index + 1
				if !s.memory_db {
					
					s.count("sql_insert")

					stmt, err := s.dbHandle.Prepare("insert into StringTable(id, value) values(?, ?)")
					
					if err != nil {
						log.Println("While preparing to insert ", aStr, " into  StringTable: ", err)
					}
					
					defer stmt.Close()
					
 					_, err = stmt.Exec( s.next_string_index, bytes(aStr))
					//fmt.Printf("insert into StringTable(id, value) values(%v, %s)\n",s.next_string_index, aStr)
					if err != nil {
						log.Println("While trying to insert ", aStr, " into StringTable: ", err)
					}
					

					s.count("sql_insert")
					stmt, err = s.dbHandle.Prepare("insert into SymbolTable(id, value) values(?, ?)")
					
					if err != nil {
						log.Println("While preparing to insert  ", aStr, " into SymbolTable: ", err)
					}
					
					defer stmt.Close()
					
					_, err = stmt.Exec(bytes(aStr), s.next_string_index)
					//fmt.Printf("insert into SymbolTable(id, value) values(%s, %v)\n",aStr,  s.next_string_index)
					if err != nil {
						log.Println("While trying to insert ", aStr, " into SymbolTable: ", err)
					}
					

				} else {
					s.string_table.Insert(patricia.Prefix(aStr), s.next_string_index)
					if s.next_string_index < len(s.reverse_string_table)-1 {
						if s.debug {
							log.Println("Inserting tag into reverse string table: ", aStr)
						}
						s.reverse_string_table[s.next_string_index] = aStr

					} else {
						if s.debug {
							log.Println("Extending reverse string table for tag ", aStr)
						}
						s.reverse_string_table = append(s.reverse_string_table, aStr)
					}
				}
				if s.debug {
					log.Printf("Finished store\n")
				}
				return s.next_string_index
			}
		}
	}
}
