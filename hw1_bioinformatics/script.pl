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

#STEP 1
sub rand_seq {
    my $len = shift;
    my $seq = "";

    $str="";  # str concatenate 20 substr, one for each amino acid i with len= PAM1[i][i] 
    for($i=0;$i<=$#aa;$i++){
        $k=$s{$aa[$i]}{$aa[$i]}; # k = number of repeation of amino acid i
        for($j=0;$j<$k; $j++){
            $str .= $aa[$i];
        }
    }

    $i=0;
    while($i<$len) {
        $r = int(rand()*$tot);  #tot = total len of str
        $seq .= substr($str, $r, 1);	# concatenate aa in $str at positin $r to $seq
        $i++;
    }
    
    return $seq;
}

my $seq_a = rand_seq(500);
#print "$seq_a\n";

# STEP 2
sub mutate_seq {
    my $seq = shift;
    my $mstr = "";  # str concatenate 20 substr, one for each amino acid i with len= PAM1[i][i] 
    # PAM   A   R   N
    # D     6   0   42
    # Then aa_mut{D} = "AAAAANNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"
    my %aa_mut;
    my $seq_mut = "";

    # Loop through amino acids to fill out %aa_mut
    for ($i = 0; $i <= $#aa; $i++){
        # For each amino acid, look through every other amino acid.
        for ($j = 0; $j <= $#aa; $j++) {
            # Look up mutation rate of amino acid in PAM (in this case its s=PAM)
            $k = $s{$aa[$i]}{$aa[$j]}; # k = number of repeation of amino acid i
            for($l = 0; $l < $k; $l++){
                $mstr .= $aa[$j];
            }
        }
        @aa_mut{$aa[$i]} = $mstr;
        $mstr = "";
    }

    foreach $c (split //, $seq) {
        my $choices = $aa_mut{$c};
        $r = int(rand() * length $choices);  
        $seq_mut .= substr($choices, $r, 1);
    }

    return $seq_mut;
}

$seq_a_mutated = mutate_seq($seq_a);
#print "$seq_a_mutated\n";

# Given an array and a char, return the probabil-
# ity of finding that char in the entire string.
sub str_occ {
    my @a = @{$_[0]};
    my $m = $_[1];

    $c = 0;

    foreach $s (@a) {
        if ($s eq $m) {
            $c++;
        }
    }
    
    return $c / ($#a + 1);
}

# STEP 3
sub step_3 {
    my $ancestor = rand_seq(500);
    
    my $mutant1 = mutate_seq($ancestor);
    my $mutant2 = mutate_seq($ancestor);

    for (my $i = 0; $i < 50; $i++) {
        $mutant1 = mutate_seq($mutant1);
        $mutant2 = mutate_seq($mutant2);
    }

    # Generate f(AA) lookup array into $f
    my @both_mutants = split //, $mutant1 . $mutant2;
    for (my $i = 0; $i <= $#aa; $i++) {
        $f{$aa[$i]} = str_occ(\@both_mutants, $aa[$i]);
    }

    # Generate f(i, j) lookup matrix into $ff
    for (my $i = 0; $i < length $mutant1; $i++) {
        push @aligned_mutants, substr($mutant1, $i, 1) . substr($mutant2, $i, 1);
    }

    for (my $i = 0; $i <= $#aa; $i++) {
        for (my $j = 0; $j <= $#aa; $j++) {
            $ff{$aa[$i]}{$aa[$j]} = str_occ(\@aligned_mutants, $aa[$i] . $aa[$j])
        }
    }

    # Generate our scoring matrix s2
    # S(i,j) = log [ f(i,j) / (f(i) f(j)) ]
    my $s2;
    for (my $i = 0; $i <= $#aa; $i++) {
        $fi = $f{$aa[$i]};
        for (my $j = 0; $j <= $#aa; $j++) {
            $fj = $f{$aa[$j]};
            $fij = $ff{$aa[$i]}{$aa[$j]};
            
            if ($fij == 0) {
                $score = 0;
            } else {
                $score = log($fij / ($fi * $fj));
            }

            $s2{$aa[$i]}{$aa[$j]} = $score;
        }
    }

    # Print out s2 in nice format
    print "\t";
    for (my $i = 0; $i <= $#aa; $i++) {
        printf "%5s\t", $aa[$i];
    }
    print"\n";
    for (my $i = 0; $i <= $#aa; $i++) {
        printf "%5s\t", $aa[$i];
        for (my $j = 0; $j <= $#aa; $j++) {
            my $curr = $s2{$aa[$i]}{$aa[$j]};
            if ($curr == 0) {
                printf "%5d\t", 0;
            } else {
                printf "%5.2f\t", $curr;
            }
        }
        print "\n";
    }
}
step_3();

