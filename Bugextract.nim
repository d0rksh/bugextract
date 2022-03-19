import json
import marshal
import threadpool
import cpuinfo
import re
import sequtils
import httpclient
import strutils
import sugar
let thread_count = countProcessors()
setMaxPoolSize(thread_count)
type
  Pattern* = object
    display*, pattern_type*,regex*: string
var file:string = readFile("./patterns.json")
let patterns: seq[Pattern] = to[seq[Pattern]](file)
var input = readAll(stdin)
echo "\u001b[31m"
echo """
   _                           _                  _
 | |                         | |                | |
 | |__  _   _  __ _  _____  _| |_ _ __ __ _  ___| |_
 | '_ \| | | |/ _` |/ _ \ \/ / __| '__/ _` |/ __| __|
 | |_) | |_| | (_| |  __/>  <| |_| | | (_| | (__| |_
 |_.__/ \__,_|\__, |\___/_/\_\\__|_|  \__,_|\___|\__|
               __/ |
              |___/
                                     by d0rksh
"""
echo "\u001b[0m"
proc make_request(site:seq[string],pattern:seq[Pattern]):void=
        try:
          for s in site:
            echo "\u001b[32;1mURL => ["&s&"] \u001b[0m"
            var client = newHttpClient()
            var content = client.request(s,HttpGet)
            var body = content.body()
            var body_split = split(body,"\n")
            var body_line_legth = body_split.map(x=>findBounds(body,re(x)))
            for p in pattern:
              var found = findBounds(body,re(p.regex))
              for match in findAll(body,re(p.regex)):
                  echo "\u001b[32;1m====================\u001b[0m"
                  var matched_start = found[0]
                  var echoed = false
                  for index,b in body_line_legth:
                      var start_b = b[0]
                      var end_b = b[1]
                      if matched_start >= start_b and matched_start <= end_b:
                           echo "Regex Name: " & p.display
                           echo "Line " & intToStr(index+1) & ":  \u001b[31m" & match & "\u001b[0m"
                           echoed = true
                  if not echoed:
                      echo "Regex Name: " & p.display
                      echo "Found:" & "\u001b[31m" & match & "\u001b[0m"

            client.close()
        except:
          discard
var all_url = split(input,"\n")
var sub_seq = all_url.distribute(thread_count)
if all_url.len() <= thread_count:
 for s in all_url:
    var single_seq:seq[string] = newSeq[string]()
    if s != "":
      single_seq.add(s)
    spawn make_request(single_seq,patterns)
else:
  for s in sub_seq:
    spawn make_request(s,patterns)
sync()
# mport re
# // import httpclient
# // import strutils
# // var input = readAll(stdin)
# // echo "\u001b[31m"
# // echo """
# //                 _            _                  _
# //                 | |          | |                | |
# //    ___ _ __ ___ | |_ _____  _| |_ _ __ __ _  ___| |_
# //   / __| '_ ` _ \| __/ _ \ \/ / __| '__/ _` |/ __| __|
# //  | (__| | | | | | ||  __/>  <| |_| | | (_| | (__| |_
# //   \___|_| |_| |_|\__\___/_/\_\\__|_|  \__,_|\___|\__|

# //                                      by d0rksh
# // """
# // echo "\u001b[0m"
# // for l in split(input,"\n"):
# //     try:
# //         var client = newHttpClient()
# //         var content = client.get(l)
# //         var string_content =  content.body()
# //         echo "\u001b[32;1m URL => ["&l&"] \u001b[0m"
# //         for match in findAll(string_content,re"(/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/)|(//.*)"):
# //            echo "--------------------------"
# //            echo match
# //            echo "--------------------------"
# //         client.close()
# //     except:
# //            continue

