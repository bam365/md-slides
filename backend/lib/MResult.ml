type error = string

type 'a t = ('a, error) CCResult.t

module Let = Containers_let.Let.Result.Make(struct type err = error end)
