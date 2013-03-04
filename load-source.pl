use strict;

my $demos = {
  "perl"   => "demo.pl",
  "python" => "demo.py",
  "bash"   => "demo.sh",
  "c"      => "demo.c",
  "R"      => "demo.R",
};

my $source;
while( my($lang, $file) = each(%$demos) )
{
  local $/ = undef;
  open(my $IN, "<", $file) or die("error: unable to open '$file'");
  $source->{$lang} = <$IN>;
}

my $markup = do
{
  local $/ = undef;
  <STDIN>;
};

while( my($lang, $file) = each(%$demos) )
{
  my $search  = "<$file>";
  my $replace = $source->{$lang};
  $markup =~ s/$search/$replace/;
}
print $markup;
