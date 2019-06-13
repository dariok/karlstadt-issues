xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

let $n := 216
let $coll := "/db/edoc/ed000" || $n || "/texts/"

let $fgs := for $f in collection($coll)//tei:TEI
    let $u := base-uri($f)
    let $local := substring-after($u, $coll)
    let $c := substring-before($local, '/')
    let $r := substring-after($local, '/')
    group by $t := substring-after(substring($f/@xml:id, 16), '_')
    return <filegroup xml:id="f{$n || $t}">{
        for $file in $f return
            <file path="{$u}"
                uuid="{util:uuid($file)}" 
                date="{$c}"
                order="$file/@n" />
    }</filegroup>

return xmldb:store($coll, 'filegroup.xml', <fg>{$fgs}</fg>)