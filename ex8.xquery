(: 8. Keressük meg azon egyénnek (vagy egyéneknek) az azonosítóját, aki(k) a legtöbb nóbel díjat kapta :)
xquery version "3.1";

(: XSD importálása :)
import schema default element namespace "" at "./ex8.xsd";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

(: Nobel-díjasok betöltése :)
let $laureates := fn:json-doc("./laureates.json")?*

let $max-nobels := (for $l in $laureates
    order by fn:count($l?nobelPrizes?*) descending
return
    fn:count($l?nobelPrizes?*))[1]

return
    validate {
        document {
            element maxNobels {
                attribute count {$max-nobels},
                for $l in $laureates
                    where fn:count($l?nobelPrizes?*) = $max-nobels
                return
                    element name {
                        $l
                    }
            }
        }
    }