function validate_replication_variables() {
  if ! [[ -v MYSQL_DATABASE && -v MYSQL_USER && -v MYSQL_PASSWORD && \
        ( "${MYSQL_RUNNING_AS_SLAVE:-0}" != "1" || -v DATABASE_SERVICE_NAME ) ]]; then
    echo
    echo "For master/slave replication, you have to specify following environment variables:"
    echo "  DATABASE_SERVICE_NAME (slave only)"
    echo "  MYSQL_DATABASE"
    echo "  MYSQL_USER"
    echo "  MYSQL_PASSWORD"
    echo
  fi
  [[ "$MYSQL_DATABASE" =~ $mysql_identifier_regex ]] || usage "Invalid database name"
  [[ "$MYSQL_USER"     =~ $mysql_identifier_regex ]] || usage "Invalid MySQL master username"
  [ ${#MYSQL_USER} -le 16 ] || usage "MySQL master username too long (maximum 16 characters)"
  [[ "$MYSQL_PASSWORD" =~ $mysql_password_regex   ]] || usage "Invalid MySQL master password"
}

validate_replication_variables
