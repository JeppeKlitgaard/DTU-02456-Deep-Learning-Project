$
underbrace(f(theta), "obj") = cases(
  a b [theta/2] & "if" norm(bold(v)) >= 1,
  integral_(cal(M)) r dif theta & "else"
)
$
