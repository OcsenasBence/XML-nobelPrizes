(: 6. Kontinensenkénti Nóbel díjasok születtek. A sorrend a count szerint csökkenő sorrendben.:)
xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

(: Nobel-díjasok betöltése :)
let $laureates := fn:json-doc("./laureates.json")?*

(: Kontinensek és Nobel-díjasok számlálása :)
let $continent-counts := 
    for $laureate in $laureates
    let $continent := $laureate?birth?place?continent?en
    where exists($continent)
    group by $continent
    let $count := count($laureate)
    order by $count descending
    return map {
        "Kontinens": $continent,
        "Nóbel díjak száma": $count
    }
(: JSON kimenet beállítása :)
return array { $continent-counts }