(: 9. Listázd azokat a Nóbel-díjasokat, akik már meghaltak és Németországban születtek.:)
xquery version "3.1";


(: Nobel-díjasok betöltése :)
let $laureates := fn:json-doc("./laureates.json")?*

(:  Szűrés és eredmény generálása :)
for $laureate in $laureates
where exists($laureate?death) (:  Csak azokat választja ki, akik már meghaltak :)
      and $laureate?birth?place?country?en eq "Germany" (:  Németországban születettek :)
return 
  <laureate>
    <id>{ $laureate?id }</id>
    <name>{ $laureate?knownName?en }</name>
    <birthPlace>{ $laureate?birth?place?locationString?en }</birthPlace>
    <birthDate>{ $laureate?birth?date }</birthDate>
    <deathDate>{ $laureate?death?date }</deathDate>
  </laureate>