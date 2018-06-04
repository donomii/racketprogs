module Main where

import IO
import System
import List(isSuffixOf) 
import Data.HashTable

parse fname str = str 

main::IO()
main = do 
    arguments <- getArgs
    if (length (arguments)==0) 
     then putStrLn "No input file given.\n Proper way of running program is: \n program input.in"
      else do
            let fileName = (head arguments)
            contents <- slurpFile(fileName)
            putStrLn contents;
            exitWith ExitSuccess                                          



slurpFile fileName = do
               handle <- catch (openFile fileName ReadMode) 
                   (\e -> error $ show e)                                           
               readable<- hIsReadable handle
               if (not readable)
                   then error "File is being used by another user or program"
                   else do
                       unparsedString <- hGetContents handle
                       return unparsedString


