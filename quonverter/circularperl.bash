#!/bin/bash
perl test.pl compiler.qon > test2.pl
diff test.pl test2.pl
perl test2.pl compiler.qon > test.pl
diff test.pl test2.pl
