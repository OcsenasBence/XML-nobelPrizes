(: 3. Listázza a 2000-ben történt díjazásokat. :)
xquery version "3.1";

(: Nobel-díjak XML érvényesítéséhez importáljuk az XSD-t :)
import schema default element namespace "" at "./ex3.xsd";

(: Nobel-díjasok betöltése :)
let $laureates := fn:json-doc("./laureates.json")?*

return 
 validate { 
  document {
    element nobelPrizes {
      for $laureate in $laureates
      for $prize in $laureate?nobelPrizes?*
      where $prize?awardYear = "2000"
      return element nobelPrize {
        element id { $laureate?id },
        element name { $laureate?knownName?en },
        element category { $prize?category?en },
        element motivation { $prize?motivation?en },
        element awardYear { $prize?awardYear }
      }
    }
  }
} 
