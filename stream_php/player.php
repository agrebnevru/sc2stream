<?php
require_once 'stream/stream.class.php';
$strm = new Streaming;
$Check_MyIE = $strm->Check(0, 16430);
$Check_BeeS = $strm->Check(0, 21640);

if (!preg_match('|forum|si', $_SERVER[REQUEST_URI])) {
?>
<div style="text-align:center; border:1px solid #E4E4E4; padding: 10px 10px 0px 10px;">


<div class="section vertical">
<ul class="tabs">
<li class="current">Видео с CTD [<span style='color:#00FF00;'>ON</span>]</li>
<?php
if ($Check_MyIE) { echo "<li>MyIE [<span style='color:#00FF00;'>ON</span>]</li>"; } else { echo "<li>MyIE [<span style='color:red;'>OFF</span>]</li>"; }
if ($Check_BeeS) { echo "<li>BeeS [<span style='color:#00FF00;'>ON</span>]</li>"; } else { echo "<li>BeeS [<span style='color:red;'>OFF</span>]</li>"; }
?>
</ul>

<div class="box visible">
<object width="640" height="480">
<param name="movie" value="http://www.youtube.com/p/46DCC7BF87C4A2EB?hl=ru_RU&fs=1"></param>
<param name="allowFullScreen" value="true"></param>
<param name="allowscriptaccess" value="always"></param>
<embed src="http://www.youtube.com/p/46DCC7BF87C4A2EB?hl=ru_RU&fs=1" type="application/x-shockwave-flash" width="640" height="480" allowscriptaccess="always" allowfullscreen="true"></embed>
</object>
</div>

<div class="box">
<object width='640' height='480'>
<param name='movie' value='http://www.own3d.tv/livestream/16430' />
<param name='allowfullscreen' value='true' />
<param name='wmode' value='transparent' />
<embed src='http://www.own3d.tv/livestream/16430' type='application/x-shockwave-flash' allowfullscreen='true' width='640' height='480' wmode='transparent'></embed>
</object>
</div>

<div class="box">
<object width='640' height='480'>
<param name='movie' value='http://www.own3d.tv/livestream/21640' />
<param name='allowfullscreen' value='true' />
<param name='wmode' value='transparent' />
<embed src='http://www.own3d.tv/livestream/21640' type='application/x-shockwave-flash' allowfullscreen='true' width='640' height='480' wmode='transparent'></embed>
</object>
</div>


</div>
</div>
<?php
}
?>
