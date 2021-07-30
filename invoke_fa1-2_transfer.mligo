type tokens = (address, nat) big_map
type allowances = (address * address, nat) big_map (* (sender,account) -> value *)

type storage = nat

type transfer = [@layout:comb]{ from : address; [@annot:to]to_: address; value: nat; }

type entry =
| Proxy
| Nop3

let call (en:entry) : operation list =
    match en with
    | Proxy  ->
        (match (Tezos.get_entrypoint_opt "%transfer" ("KT18pBMWjE2j77TQwDqPbVCtJ3sZwZpDCcPY":address) : transfer contract option) with
        | Some c -> ([Tezos.transaction {from = Tezos.source; to_ = Tezos.source; value=5n;} 0tez c] : operation list)
        | _ -> (failwith "Not a valid fa1.2 contract" : operation list))
    | _ -> failwith "no"
let main (e,s:entry * storage) =
    call e, s+1n

// https://ide.ligolang.org/p/jmxwN1kpsM_iEpfHf-Ur4Q
// notice the [@layout:comb] necessary to generate a right balanced pair tree and the [@annot:to] to overcome the fact that "to" is a reserver keyword
