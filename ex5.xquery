(: 5. Halott Nobel-díjasok kiválasztása és rendezése ABC sorrendben. :)
xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

(: Nobel-díjasok betöltése :)
let $laureates := fn:json-doc("./laureates.json")?*

(: Halott Nobel-díjasok kiválasztása és rendezése ABC sorrendben :)
let $deceased := 
    array {
        for $laureate in $laureates
        where exists($laureate?death)
        order by $laureate?knownName?en
        return map {
            "id": $laureate?id,
            "name": $laureate?knownName?en,
            "birthDate": $laureate?birth?date,
            "deathDate": $laureate?death?date,
            "birthPlace": $laureate?birth?place?city?en || ", " || $laureate?birth?place?country?en,
            "deathPlace": $laureate?death?place?city?en || ", " || $laureate?death?place?country?en
        }
    }

(: JSON kimenet beállítása :)
return $deceased
