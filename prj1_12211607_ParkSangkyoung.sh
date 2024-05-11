#!/bin/bash
if [ $# -ne 3 ]
then
	echo "usage: ./oss-prj.sh teams.csv players.csv. matches.csv"
	exit 1
else
       	if [ "$1" != "teams.csv" ] || [ "$2" != "players.csv" ] || [ "$3" != "matches.csv" ]
	then
		echo "check the file name and order"
		echo "usage: ./oss-prj.sh teams.csv players.csv matches.csv"
		exit 1
	fi
fi


	echo "************OSS1 - Project1************"
	echo "*        StudentID : 12211607         *"
	echo "*       Name : Sangkyoung Park        *"
	echo "***************************************"
until [ "$choice" = "7" ]
do	
	echo -e "\n[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in players.csv"
	echo "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendance matches in mateches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of date_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
	echo "7. Exit"
	read -p "Enter your CHOICE (1~7) : " choice

	case "$choice" in

		1) read -p "Do you want to get the Heung-Min Son's data? (y/n) : " yn
			if [ "$yn" = "y" ]
			then
				cat $2 | awk -F, '$1~"Heung"{print "Team:"$4", Apperance:"$6", Goal:"$7", Assist:"$8}'
			else
				echo "retry!"
			fi;;


		2) read -p "What do you want to get the team data of league_position[1~20] : " grade
			cat teams.csv | awk -F, -v a=$grade '$6==a{print $6,$1,$2/($2+$3+$4)}';;


		3) read -p "Do you want to know Top-3 attendance data and average attendance? (y/n) : " yn
			if [ "$yn" = "y" ]
			then
				echo "***Top-3 Attendance Match***"
				cat matches.csv | sort -t, -r -nk 2 | head -n 3 | awk -F, '{print"\n" $3" vs "$4 " ("$1")" "\n" $2" " $7}'
			else
				echo "retry!"
			fi;;

		4) read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " yn
			if [ "$yn" = "y" ]
			then

				for var in $(seq 1 20)
				do
					result=$(cat teams.csv | awk -F, -v a=$var '$6==a{print $1}')
					cat teams.csv | awk -F, -v a="$result" '{if($1==a) print $6" "$1}'
					cat players.csv | sort -t, -k7,7rn | awk -F, -v team="$result" '$4==team {print $1 " " $7}' | head -n 1
				
				done
				
			else
				echo "retry!"
			fi;;

		5) read -p "Do you want to modify the format of date? (y/n) : " yn

			if [ "$yn" = "y" ]
			then
				cat matches.csv | head -n 10 |  awk -F, '{print $1}' | sed 's/\([^ ]*\) \([^ ]*\) \([^ ]*\) \([^ ]*\)/\3\/08\/\2/'
			else
				echo "retry!"
			fi;;
		6)
		echo "1) Arsenal		11) Liverpool"
		echo "2) Tottenham Hotspur	12) Chelsea"
		echo "3) Manchester City	13) West Ham United"
		echo "4) Leicester City	14) Watford"
		echo "5) Crystal Palace	15) Newcastle United"
		echo "6) Everton 		16) Cardiff City"
		echo "7) Burnley 		17) Fulham"
		echo "8) Southampton 		18) Brighton & Hove Albion"
		echo "9) AFC Bournemouth 	19) Huddersfield Town"
		echo "10) Manchester United 	20) Wolverhampton Wanderers"
		read -p "Enter your team number : " num

		hometeam=$(cat teams.csv | awk -F, -v a=$num '(NR-1)==a{print $1}')
		
		touch match.txt

		cat matches.csv | awk -F, -v a="$hometeam" '$3==a{print $5-$6}' | sort -r -n >> match.txt
		
		
		highnum=$(cat match.txt | awk 'NR==1{print}')
		
		cat matches.csv | awk -F, -v a=$highnum -v b="$hometeam" '{if ($3==b && $5-$6==a) print $1"\n"$3" "$5" vs "$6" "$4}'

		rm -rf match.txt
		;;

		



		7) echo "Bye!"
	esac
done
