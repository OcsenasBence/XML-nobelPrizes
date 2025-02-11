(: 2. Kategóriánként rendezés a nóbeldíjakat es xml-t adjon vissza  :)
xquery version "3.1";

import schema default element namespace "" at "./ex2.xsd";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";


let $laureates := fn:json-doc("./laureates.json")?*

let $categories := fn:distinct-values(
  for $l in $laureates
    let $prizes := $l?nobelPrizes?*
    for $prize in $prizes
      let $cat := $prize?category?en
      return $cat
)

return validate {
  document {
    element categories {
      for $c in $categories
      return element category { attribute name {$c},
        for $l in $laureates
          let $prizes := $l?nobelPrizes?*
          for $p in $prizes
            let $category := $p?category?en
            return
            if (fn:compare($c, $category) = 0) then
              element laureate {
                element id {xs:integer($l?id)},
                element fullName {$l?fullName?en},
                element givenName {$l?givenName?en},
                element familyName {$l?familyName?en},
                element birthDate {$l?birth?date},
                element awardYear {xs:integer($p?awardYear)},
                element motivation {$p?motivation?en},
                element prizeAmount {xs:integer($p?prizeAmount)},
                element affiliation {
                  for $affiliation in $p?affiliations?*
                  return element institution {
                    element name {$affiliation?name?en},
                    element city {$affiliation?city?en},
                    element country {$affiliation?country?en}
                  }
                }
              }
            else ()
      }
    }
  }
}