#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';
use Kernel::System::ObjectManager;
use Kernel::System::DynamicField;
use Kernel::System::Ticket;
local $Kernel::OM = Kernel::System::ObjectManager->new();
my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

local $Kernel::OM = Kernel::System::ObjectManager->new(
'Kernel::System::Log' => {
LogPrefix => 'OTRS Dynamic Field Update',
},
);

my %Options;
use Getopt::Std;
getopts( 'h:d:v:o:', \%Options );
if ( $Options{h} ) {
print STDERR "Usage: -d <Dynamic Field Value> -v <Set Value>  -o <TicketNumber>\n";
exit;
}
if ( $Options{d} || $Options{v} || $Options{o} ) {
my %Param=(
UserID => '1',
F => $Options{d},
V => $Options{v},
O => $Options{o},
);
my $TicketID = $TicketObject->TicketIDLookup(
TicketNumber => $Param{O},
UserID => 1,
);

my $DynamicFieldID = $DynamicFieldObject->DynamicFieldGet(
Name => $Param{F},
);

my $DFV = $DynamicFieldID->{ID};

my $S2 = $DynamicFieldValueObject->ValueSet(
FieldID => $DFV,
ObjectID => $TicketID,
Value => [
{
ValueText => $Param{V},
}
],
UserID => $Param{UserID},
);
 print "Set DynamicField: $Options{d} DynamicFieldID: $DFV Value: $Options{v} Object: $Options{o} ID DO TICKET: $TicketID\n";
}
exit(0);
