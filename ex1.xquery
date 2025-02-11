xquery version "3.1";

import module namespace deik-utility = "http://www.inf.unideb.hu/xquery/utility" at "https://arato.inf.unideb.hu/jeszenszky.peter/FejlettXML/lab/lab10/utility/utility.xquery";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

declare function local:get_data($offset as xs:integer) {
    let $uri := deik-utility:add-query-params("https://api.nobelprize.org/2.0/laureates",
    map {
        "offset": $offset,
        "limit": 25
    }
    )
    
    return
        fn:json-doc($uri)
};

declare function local:next_page_offset($data) {
    let $azureLink := $data?links?next
    return
        if (fn:not(fn:empty($azureLink))) then
            let $querySection := fn:tokenize($azureLink, "\?")[2]
            let $andCharacter := "&#38;"
            let $offsetSection := fn:tokenize($querySection, $andCharacter)[1]
            let $offset := fn:tokenize($offsetSection, "=")[2]
            return
                xs:integer($offset)
        else
            -1
};


declare function local:find_data($offset) {
    let $data := local:get_data($offset)
    let $nextOffset := local:next_page_offset($data)
    return
        if ($nextOffset != -1) then
            ($data?laureates?*, local:find_data($nextOffset))
        else
            ()
};

let $data :=
array {
    for $d in local:find_data(0)
    return
        $d
}
return
    $data
