xquery version "1.0-ml";

declare namespace sm = "http://marklogic.com/smoulder";

let $config :=
    <configuration xmlns="http://marklogic.com/smoulder">
        <plurals>
            <plural plural="people" singular="person"/>
        </plurals>
    </configuration>

return xdmp:document-insert(
        "/admin/configuration.xml",
        $config,
        xdmp:default-permissions(),
        xdmp:default-collections()
)