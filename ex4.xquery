(: 4. Legkisebb prizeAmount-tal rendelkező Nobel-díjak :)
xquery version "3.1";

import schema default element namespace "" at "./ex4.xsd";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

(: Nobel-díjasok betöltése :)
let $laureates := fn:json-doc("./laureates.json")?*

(: Minden prizeAmount összegyűjtése :)
let $allPrizes := 
    for $laureate in $laureates
    for $prize in $laureate?nobelPrizes?*
    return 
        <prize>
            <id>{ $laureate?id }</id>
            <name>{ $laureate?knownName?en }</name>
            <category>{ $prize?category?en }</category>
            <motivation>{ $prize?motivation?en }</motivation>
            <awardYear>{ $prize?awardYear }</awardYear>
            <prizeAmount>{ $prize?prizeAmount }</prizeAmount>
        </prize>

(: Legkisebb prizeAmount meghatározása :)
let $minPrizeAmount := min($allPrizes/prizeAmount)

(: Legkisebb prizeAmount-hoz tartozó Nobel-díj :)
return validate {
  document {
    element prizes {
            for $prize in $allPrizes
            where $prize/prizeAmount = $minPrizeAmount
            return $prize
        }
    }
}