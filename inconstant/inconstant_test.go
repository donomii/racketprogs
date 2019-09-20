package main
import "testing"

func tomlTestString() []byte {
    testData := `Age = 25
Cats = [ "Cauchy", "Plato" ]
Pi = 3.14
Perfection = [ 6, 28, 496, 8128 ]
DOB = 1987-07-05T05:45:00Z
`
return []byte(testData)
}

func sexpTestString() []byte {
    testData := `(defun factorial (x)
   (if (zerop x)
       1
       (* x (factorial (- x 1)))))
`
return []byte(testData)
}

func yamlTestString() []byte {
    testData := `invoice: 34843
date   : 2001-01-23
bill-to: &id001
    given  : Chris
    family : Dumars
    address:
        lines: |
            458 Walkman Dr.
            Suite #292
        city    : Royal Oak
        state   : MI
        postal  : 48046
ship-to: *id001
product:
    - sku         : BL394D
      quantity    : 4
      description : Basketball
      price       : 450.00
    - sku         : BL4438H
      quantity    : 1
      description : Super Hoop
      price       : 2392.00
tax  : 251.42
total: 4443.52
comments: >
    Late afternoon is best.
    Backup contact is Nancy
    Billsmer @ 338-4338.
`
return []byte(testData)
}



func jsonTestString() []byte {
     testData := `
    {
    "glossary": {
        "title": "example glossary",
		"GlossDiv": {
            "title": "S",
			"GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
					"SortAs": "SGML",
					"GlossTerm": "Standard Generalized Markup Language",
					"Acronym": "SGML",
					"Abbrev": "ISO 8879:1986",
					"GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
						"GlossSeeAlso": ["GML", "XML"]
                    },
					"GlossSee": "markup"
                }
            }
        }
    }
}
`

return []byte(testData)
}


func TestToml(t *testing.T) {
_, err := unmarshalToml([]byte(tomlTestString()))
if err != nil {
    t.Error() // to indicate test failed
}
}


func TestJson(t *testing.T) {
   _, err := unmarshalJson([]byte(jsonTestString()))
if err != nil {
    t.Error() // to indicate test failed
}
}

func TestYaml(t *testing.T) {
   _, err := unmarshalYaml([]byte(yamlTestString()))
if err != nil {
    t.Error() // to indicate test failed
}
}

func TestSexp(t *testing.T) {
   _, err := unmarshalSexp([]byte(sexpTestString()))
if err != nil {
    t.Error() // to indicate test failed
}
}


func TestParseAny(t *testing.T) {
  parseAny(tomlTestString())
  parseAny(jsonTestString())
  parseAny(yamlTestString())
  parseAny(sexpTestString())
}
