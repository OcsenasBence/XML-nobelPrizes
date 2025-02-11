(:7. JSON tömbbe az Európai női nóbel díjasokat akik 1920 és 2000 között kaptak Nóbel díjat. 
Az eredményt ABC szerint csökkenő sorrendben szemléltesd:)
xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

let $laureates := fn:json-doc("./laureates.json")?*
let $filtered :=
  for $laureate in $laureates
  let $continent := $laureate?birth?place?continent?en
  let $gender := $laureate?gender
  let $nobelPrizes := $laureate?nobelPrizes?*
  where $continent = "Europe" and $gender = "female"
        and exists(
          for $prize in $nobelPrizes
          where xs:integer($prize?awardYear) >= 1920 and xs:integer($prize?awardYear) <= 2000
          return $prize
        )
  let $firstPrize := $nobelPrizes
  return map {
    "name": $laureate?knownName?en,
    "birthPlace": $laureate?birth?place?locationString?en,
    "awardYear": $firstPrize?awardYear
  }

let $sorted :=
  for $item in $filtered
  order by $item("name") descending
  return $item

return array { $sorted }