use Data::Dumper;

@test_seq1 = split //, "AGGCCTGAAAGTCCGTCGTCGGAACGCGATCTTGCGACATCCCGAATATCCGTTCATGATTGCCAATATC";
@test_seq2 = split //, "GAGAAGTGGAGGCGCTCATCGCAGAATTAGAGGCAGTGAACGCGGAGATCAAGCAGAAGAGCGAGAGAAAGGCGGAGATTGAG";
$s1_len = $#test_seq1 + 1;
$s2_len = $#test_seq2 + 1;

$id_score = 4;              # AA/CC/GG/TT match
$transition_score = -2;     # AG or CT match
$transversion_score = -3;   # All others
$gap_score = -8;

print "$s1_len $s2_len\n";
for (my $i = 0; $i < $s1_len; $i++) {
    $M[$i][0] = $gap_score * $i;
}
for (my $j = 0; $j < $s2_len; $j++) {
    $M[0][$j] = $gap_score * $j;
}

for (my $i = 1; $i < $s1_len; $i++) {
    for (my $j = 1; $j < $s2_len; $j++) {
        $M[$i][$j] = 0;
    }
}

# PRINT OUT THE TABLE
for (my $j = 1; $j < $s2_len; $j++) {
    print "$test_seq2[$j]\t";
}
print "\n";

for ($i = 0; $i < $s1_len; $i++) {
    print "$test_seq1[$i]\t";
    for ($j = 0; $j < $s2_len; $j++) {
        printf "%2d\t", $M[$i][$j];
    }
    print "\n";
}
