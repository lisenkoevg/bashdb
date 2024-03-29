# bashdb - a bash debugger
# Driver Script: concatenates the preamble and the target script
# and then executes the new script.

echo 'bash Debugger version 1.0'

_dbname=${0##*/}
_curdir=$(dirname $(realpath $0))

if (( $# < 1 )); then
  echo "$_dbname: Usage: $_dbname filename" >&2
  exit 1
fi

_guineapig="$1"

if [ ! -r "$1" ]; then
  echo "$_dbname: Cannot read file '$_guineapig'." >&2
  exit 1
fi

shift

_tmpdir="$_curdir/tmp"
mkdir -p "$_tmpdir"
_libdir="$_curdir"
_debugfile="$_tmpdir/bashdb.$$"
sed -n '$p' "$_libdir/bashdb.pre" |
  grep -q $(wc -l "$_libdir/bashdb.pre") || { echo Wrong LINENO in bashdb.pre; exit 1; }
cat "$_libdir/bashdb.pre" "$_guineapig" > "$_debugfile"
exec bash "$_debugfile" "$_guineapig" "$_tmpdir" "$_libdir" "$@"

