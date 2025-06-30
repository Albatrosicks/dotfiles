function envup --description "Load .env file into shell session"
    if test -f .env
        for line in (cat .env | grep -v '^#' | grep -v '^$')
            set -gx (string split -m 1 '=' $line)
        end
    else
        echo 'No .env file found' >&2
        return 1
    end
end
