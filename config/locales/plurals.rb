{
    ru: {
        i18n: {
            plural: {
                rule: ->(n) {
                  if n % 10 == 1 && n % 100 != 11
                    :one
                  elsif (2..4).include?(n % 10) && !(12..14).include?(n % 100)
                    :few
                  else
                    n % 10 == 0 || (5..9).include?(n % 10) || (11..14).include?(n % 100) ? :many : :other
                  end
                }
            }
        }
    }
}
