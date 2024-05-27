<?php
class Streaming {

  // param  - integer $service
  // param  - string $id
	// return - boolean
	public function Check($service, $id) {
	  $resul = false;
		switch($service) {
			case 0: // own3d
        $html = file_get_contents("http://static.ec.own3d.tv/live_tmp/".$id.".txt");
        if ( preg_match( "|liveStatus=true|si", $html, $match ) ) {
           $resul = true;
         }
        break;
			case 1: // justin
			  $html = file_get_contents("http://api.justin.tv/api/stream/search/".$id.".json");
        if ( preg_match( "|live|si", $html, $match ) ) {
           $resul = true;
         }        
        break;
      default:
        $resul = false;
        break;
		}
	  return $resul;
	}

	private function Otladka() {
    // text
	}	

}	
?>
