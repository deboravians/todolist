User.find_or_create_by!(email: "dev@local") do |u|
  u.name = "Usuário Dev"
end