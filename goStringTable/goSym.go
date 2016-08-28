		}

	} else {

		var res int
		s.count("sql_select")

		err := s.dbHandle.QueryRow("select value from SymbolTable where id like ?", bytes(aStr)).Scan(&res)
		if err != nil {
			//s.LogChan["warning"] <- fmt.Sprintln("While trying to read  ", aStr, " from SymbolTable: ", err)
		}

		if err == nil {
			retval = int(res)
		} else {
			//log.Printf("Error retrieving symbol for '%v': %v", aStr, err)
		}
	}
	return retval, nil

}

func (s *tagSilo) get_or_create_symbol(aStr string) int {
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
			log.Printf("Number of Records: %v", len(s.database))
			log.Printf("Number of tags: %v", s.next_string_index+1)
			return 0
		}

		val, _ := s.get_symbol(aStr)
		if val != 0 {
			return val
		} else {
			if debug {
						log.Println("Attempting lock in get_or_create_symbol")
					}
					s.LockMe()
					defer func() {
						s.UnlockMe()
						if debug {
							log.Println("Released lock in get_or_create_symbol")
						}
					}()
					if debug {
						log.Println("Got lock in get_or_create_symbol")
					}
			val, _ := s.get_symbol(aStr)
			if val != 0 {
				return val
			} else {
				s.next_string_index = s.next_string_index + 1
				if !s.memory_db {
					
					s.count("sql_insert")

					stmt, err := s.dbHandle.Prepare("insert into StringTable(id, value) values(?, ?)")
					
					if err != nil {
						s.LogChan["error"] <- fmt.Sprintln("While preparing to insert ", aStr, " into  StringTable: ", err)
					}
					
					defer stmt.Close()
					
 					_, err = stmt.Exec( s.next_string_index, bytes(aStr))
					//fmt.Printf("insert into StringTable(id, value) values(%v, %s)\n",s.next_string_index, aStr)
					if err != nil {
						s.LogChan["error"] <- fmt.Sprintln("While trying to insert ", aStr, " into StringTable: ", err)
					}
					

					s.count("sql_insert")
					stmt, err = s.dbHandle.Prepare("insert into SymbolTable(id, value) values(?, ?)")
					
					if err != nil {
						s.LogChan["error"] <- fmt.Sprintln("While preparing to insert  ", aStr, " into SymbolTable: ", err)
					}
					
					defer stmt.Close()
					
					_, err = stmt.Exec(bytes(aStr), s.next_string_index)
					//fmt.Printf("insert into SymbolTable(id, value) values(%s, %v)\n",aStr,  s.next_string_index)
					if err != nil {
						s.LogChan["error"] <- fmt.Sprintln("While trying to insert ", aStr, " into SymbolTable: ", err)
					}
					

				} else {
					s.string_table.Insert(patricia.Prefix(aStr), s.next_string_index)
					if s.next_string_index < len(s.reverse_string_table)-1 {
						if debug {
							log.Println("Inserting tag into reverse string table: ", aStr)
						}
						s.reverse_string_table[s.next_string_index] = aStr

					} else {
						if debug {
							log.Println("Extending reverse string table for tag ", aStr)
						}
						s.reverse_string_table = append(s.reverse_string_table, aStr)
					}
				}
				s.last_tag_record = s.last_tag_record + 1
				if debug {
					log.Printf("Storing mem tag %v and disk tag %v\n", s.next_string_index, s.last_tag_record)
				}
				if s.next_string_index < len(s.tag2file)-1 {
					s.tag2file[s.next_string_index] = []*record{}

				} else {
					s.tag2file = append(s.tag2file, []*record{})

				}
				if debug {
					log.Printf("Finished store\n")
				}
				s.Dirty()
				return s.next_string_index
			}
		}
	}
}
