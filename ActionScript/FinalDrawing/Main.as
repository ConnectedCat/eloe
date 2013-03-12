﻿package  {	import flash.display.Sprite;    import flash.events.*;	import flash.net.XMLSocket;	import flash.display.MovieClip;			public class Main extends MovieClip{		private var hostName:String = "localhost";        private var port:uint = 5204;		private var kinectSocket:XMLSocket;		public function Main() {			// constructor code						kinectSocket = new XMLSocket();			configureListeners(kinectSocket);			kinectSocket.connect(hostName, port);		}				private function configureListeners(dispatcher:IEventDispatcher):void {            dispatcher.addEventListener(Event.CLOSE, closeHandler);            dispatcher.addEventListener(Event.CONNECT, connectHandler);            dispatcher.addEventListener(DataEvent.DATA, dataHandler);            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);        }        private function closeHandler(event:Event):void {            trace("closeHandler: " + event);        }        private function connectHandler(event:Event):void {            trace("connectHandler: " + event);        }        private function dataHandler(event:DataEvent):void {            trace("dataHandler: " + event.data);			        }        private function ioErrorHandler(event:IOErrorEvent):void {            trace("ioErrorHandler: " + event);        }        private function progressHandler(event:ProgressEvent):void {            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);        }        private function securityErrorHandler(event:SecurityErrorEvent):void {            trace("securityErrorHandler: " + event);        }	}//end class	}//end package