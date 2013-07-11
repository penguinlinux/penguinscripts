#
# if no command name is given
# i.e. -z $1 is defined and it is NULL
#
# if no command line arg
rememberfile=/home/mongrel/chatbot/remember.txt
extra=/home/mongrel/chatbot/extra.txt
if [ -z $1 ]
then
  rental="*** Unknown command  ***"
elif [ -n $1 ]
then
# otherwise make first arg as rental
  rental=$1
fi

case $rental in
    "cl") echo "<font face="Courier New" color=black>" 
              links --source http://$2.craigslist.org/$3/ | sed -n '/\<h4\>/,/\<\/h4\>/p' | grep "<p>" | sed s/'<p>'// | sed s/'<\/p>'// | head -n 10;;
    "clrants") echo "<font face="Courier New" color=black>"
              links --source http://$2.craigslist.org/rnr/ | sed -n '/\<h4\>/,/\<\/h4\>/p' | grep "<p>" | sed s/'<p>'// | sed s/'<\/p>'// | head -n 10;; 
    "forecast") echo "<font face="Courier New" color=black>"
                links -dump "http://www.weather.com/weather/print/$2" | sed -n '/for/,/Last/p'
                echo "<br><b>For Current Conditions type weather zipcode. example weather 90210</b>";;
    "astro") echo "<font face="Courier New" color=black>"
             echo "<b>Horoscope for $2</b>"                
             links --source http://astrology.yahoo.com/astrology/general/dailyoverview/$2 |  egrep -e 'Quickie:' -e 'Overview:' | sed 's/<b class="yastshdotxt">/<b>/';;
    "buzz") echo "<font face="Courier New" color=black>"
            links --source  http://buzz.yahoo.com/feeds/buzzoverl.xml  | grep "<title>" | sed s/'<title>'// | sed s/'<\/title>'// | sed 's/Yahoo/PenguinSmarty/' | sed 's/Buzz/Hot/' | sed 's/Index/Searches/' | sed 's/Movers//';;
    "word") echo "<font face="Courier New" color=black>"
     /usr/bin/dict -d wn $2 | sed 's/WordNet/PenguinSmarty/';;
    "secret") echo "<font face="Courier New" color=black>"
         cat /home/mongrel/chatbot/secretguide.txt;;
    "encode") echo "<font face="Courier New" color=black>" 
     key=$(/usr/local/bin/php /home/mongrel/chatbot/random.php)
     echo "<b>--Here is your encoded message--</b><br>"
     echo $2 | tr "A-Z" "a-z" | tr "a-z" "$key" 
     echo "<br>--<b>Check your Key Below</b>--<br>"
     echo "<b>Your key:</b>  $key";;
    "decode") echo "<font face="Courier New" color=black>" 
             echo $2 | tr "$3" "a-z";;
    "pjack") echo $2 >> /home/mongrel/chatbot/jacksays.txt
     echo "<h1>The following news have been entered</h1></br>" $2;;
    "jack") echo "<font face="Courier New" color=black>" 
           /home/mongrel/chatbot/jackthoughts.sh;;
    "haxor") echo "<font face="Courier New" color=black>"
              /home/mongrel/chatbot/haxor.sh "$2";;
    "postnews") echo $2 >> /home/mongrel/chatbot/extra.txt
     echo "<h1>The following news have been entered</h1></br>" $2;;
    "readnews") echo "<font face="Courier New" color=black>"
                 cat /home/mongrel/chatbot/extra.txt;;
    "nycdating") cat /home/mongrel/chatbot/dating.txt;;
    "pmale") echo $2 >> /home/mongrel/chatbot/male.txt
     echo "<h1>The following has been entered</h1></br>" $2;;
    "pfemale") echo $2 >> /home/mongrel/chatbot/female.txt
     echo "<h1>The following has been entered</h1></br>" $2;;
    "rmale") /home/mongrel/chatbot/searchmale.sh;;
    "rfemale") /home/mongrel/chatbot/searchfemale.sh;;
    "crazynews") links --dump http://www.nypost.com/news/weirdbuttrue/weirdbuttrue.htm | sed -n '/WEIRD/,/IMG/p' | sed '/\[IMG\]/d';;
    "shopcl") echo "<font face="Courier New" color=black>"
              links --dump http://$2.craigslist.org/search/sss?query="$3" | egrep -ie "$3" | head -n 25;;
    "callpenguin")
     echo  "$2" > /home/mongrel/chatbot/virginmobile.txt 
     mail -s "Message From AIM robot" 3476175145@vmobl.com < /home/mongrel/chatbot/virginmobile.txt
            echo "Your Message:  $2 </br> has been sent";;
   "erasepenguin")    rm -rf $extra
               touch  $extra
               echo "<bold>Everything is fresh</bold>";;
   "isay") echo "<font face="Courier New" color=black>"
            echo "$2" >> $rememberfile
               echo "<b>The following message has been entered:</b></br>  " "$2";;
   "remindme") grep -i $2 $rememberfile;;
   "theysay") echo "<font face="Courier New" color=black>"
              /home/mongrel/chatbot/theysay.sh;;
   "guide") cat /home/mongrel/chatbot/guide.txt;;
   "chuck") echo "<font face="Courier New" color=black>"
           /home/mongrel/chatbot/chucknorris.sh;;
   "usay") lynx --source http://www.psyops.net/index.php3 | sed -n '/<p class="myThought">/,/</p' | sed s/'<p class="myThought">'// | sed s/'<\/p>'// | sed s/'<\/td>'// | sed '/^$/d';;
   "magicball") echo "<font face="Courier New" color=black>"
                /home/mongrel/chatbot/8ball.sh;;
   "jokes")  echo "<font face="Courier New" color=black>"
             lynx --dump http://jokeathon.com/cgi-bin/random/rjokes.cgi | sed '/*-Submit.gif/d';;
   "quote")   echo "<font face="Courier New" color=black>Today's Quote"
         echo "<font face="Courier New" color=black>"
         /usr/games/fortune;;
   "weather") echo "<font face="Courier New" color=black>"
             # links --dump http://mobile.msn.com/ContentApp/default.aspx/Weather/Weather?zip=$2 | head -n 12;;
            links --dump http://weather.yahooapis.com/forecastrss?p=$2 | sed -n '/Current/,/provided/p' | head -n 7 ;
               echo "<br><b>type forecast zip to get a 10 day extended forecast. Example forecast 90210</b>";;
   "stocks")  echo "<font face="Courier New" color=black><b>Most Current Information about $2</b>"
        lynx --accept-all_cookies --dump http://finance.yahoo.com/q?s=$2 | egrep -e 'MORE ON' -e 'Last Trade:' -e 'Prev Close:' -e 'Range:' -e 'Volume:' -e 'Target Est:' -e 'Strong Buy';;
   "local") echo "<font face="Courier New" color=black>"
            lynx -dump  -useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)" http://www.google.com/pda/search?q="$2" | head -n 15 | sed 's/Google/found/g';;
    "clgigs") echo "<font face="Courier New" color=black>"
              lynx --accept_all_cookies --dump http://newyork.craigslist.org/cpg/index.rss | grep '<title>' | sed s/'<title>'// | sed s/'<\/title>'/'<br>'/;;
    "find") echo "<font face="Courier New" color=black>" 
            lynx -dump  -useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)" http://www.google.com/pda/search?q="$2" | sed -n '/References/,/10. http/p';;
    *) echo "<font face="Courier New" color=black>Sorry, but <b>$rental</b> is not a keyword. <br><br>Type <b>guide</b> for instructions";;
esac
