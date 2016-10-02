#!/usr/local/perl

# 1. Write a program that simulates the evolutionary processes, and use it to estimate PAM matrices.
# PAM1 is given at, and is used as an evolutionary model. That is, a) the rate is one mutation per 
# one hundred amino acids; b) for amino acid i, the probability to mutate to amino acid j is given 
# by the corresponding PAM1 element PAM1(i,j).

use Data::Dumper;

open(F, "pam1.txt");

$line = <F>;
$line =~ s/^\s+//;
@aa = split(/\s+/,$line); # this array has the twenty amino acids aka the first row of PAM1.txt

$i=0;
while($line = <F>) {
    @col = split(/\s+/,$line);
    shift(@col);                            # Delete first val, shift array down.
    for($j=0; $j<=$#col; $j++) {
        $s{$aa[$i]}{$aa[$j]} = $col[$j];    # Score matrix indexed by amino acid single letter code

        if($i==$j) {
            $tot += $col[$j];
        }
    }
    $i++;
}
close(F);

#print "$s{$aa[0]}{$aa[0]}\n";
#print "$s{A}{V}\n";  # you can access the score for a given amino acid pair

$str="";  # str concatenate 20 substr, one for each amino acid i with len= PAM1[i][i] 
for($i=0;$i<=$#aa;$i++){
    $k=$s{$aa[$i]}{$aa[$i]}; # k = number of repeation of amino acid i
    for($j=0;$j<$k; $j++){
        $str .= $aa[$i];
    }
}

$i=0;
while($i<500) {
    $r = int(rand()*$tot);  #tot = total len of str
    $seq .= substr($str, $r, 1);	# concatenate aa in $str at positin $r to $seq
    $i++;
}

sub mutate_seq {
    my $seq = shift;
    my $mstr="";  # str concatenate 20 substr, one for each amino acid i with len= PAM1[i][i] 
    for($i=0;$i<=$#aa;$i++){
        $k=$s{$aa[$i]}{$aa[$i]}; # k = number of repeation of amino acid i
        for($j=0;$j<$k; $j++){
            $str .= $aa[$i];
        }
    }
}

print "$seq\n";  # this is a random sequence of 500 aa
mutate_seq($seq);

print("________________________________________\n");
for ($i = 0; $i <= $#aa; $i++) {
    print "$aa[$i]";
}
