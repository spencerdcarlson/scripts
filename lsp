#!/usr/bin/perl
=begin DESCRIPTION
	written by Spencer Carlson. Simple script to imitate ls -l but print out file permissions in octal representation

	Installation:
		$ chmod 0755 lsp 
		$ mv lsp  /usr/local/bin

	Usage: 
		lsp <file_name>			prints out info of a file
		lsp <dir_name>			prints out info of a directory

	Note:
		* is not accepted
			$ lsp ~/Desktop/*	Only grabs one file on the desktop and prints out its info  
=cut

use File::stat;
use Cwd;

	chomp($input = $ARGV[0]);
	if ( $input eq "." ) {
		$dir = getcwd;
		opendir (DIR, $dir) or die $!;
		while ( my $file = readdir(DIR) ) {
			file_info($file);
		}
		exit 0;		
	}
	$input =~ s/~/$ENV{"HOME"}/;
	file_info($input);
	
	sub file_info {
		my $sb = stat($_[0]);
		my $filename;
		if ( $_[0] 	=~ m/\//g ) {
			@folders = split('/', $_[0]);
			$filename = pop(@folders);
		}else {
			$filename = $_[0];
		}
		my $user = getpwuid($sb->uid);
		my $group = getgrgid($sb->gid);
 		printf "%04o	%s	%s	%s	%d		%s	%s\n", $sb->mode & 07777, $sb->nlink, $user, $group, $sb->size, scalar localtime $sb->mtime, $filename;
	}

