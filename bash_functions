function markdown(){
  # if argv[0] string lenght does not equal zero
  if [ -z $1 ]
    then
      echo 'No markdown file specified';
      exit;
    else
      kramdown $1 | lynx -stdin;
  fi
}