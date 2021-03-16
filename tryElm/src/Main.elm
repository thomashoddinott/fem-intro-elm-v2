pluralize singular plural quantity =
    if quantity == 1 then
        singular
        
    else 
        plural

main = -- this is an inline comment
    text (pluralize "leaf" "leaves" 1)