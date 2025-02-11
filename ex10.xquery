(: 10. HTML készítése - A weboldal tartalmazza az összes Nóbel díjas id, nevét, születési dátumát és a kontinenst ahol született. :)
xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "html";
declare option output:html-version "5.0";
declare option output:indent "yes";

let $laureates := fn:json-doc("./laureates.json")?*

return
    document {
        <html
            lang="en">
            <head>
                <meta
                    charset="UTF-8"/>
                <meta
                    name="viewport"
                    content="width=device-width, initial-scale=1.0"/>
                <link
                    rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
                />
                <title>Heroes</title>
            </head>
            <body>
                <table
                    class="table table-sm">
                    <thead>
                        <tr>
                            <th
                                scope="col">Id</th>
                            <th
                                scope="col">Név</th>
                            <th
                                scope="col">Kategória</th>
                            <th
                                scope="col">Kontinens</th>
                        </tr>
                    </thead>
                    <tbody>
                        {
                            for $l in $laureates
                                order by ($l?birth?date)
                            return
                                <tr>
                                    <td>
                                        {$l?id}
                                    </td>
                                    <td>
                                        {$l?fullName?se}
                                    </td>
                                    <td>
                                        {$l?birth?date}
                                    </td>
                                    <td>
                                        {$l?birth?place?continent?en}
                                    </td>
                                </tr>
                        }
                    </tbody>
                </table>
            </body>
        </html>
    
    }