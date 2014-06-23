package kr.co.petmd.utils.gcm;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
 
import com.google.android.gcm.server.Message;
import com.google.android.gcm.server.MulticastResult;
import com.google.android.gcm.server.Result;
import com.google.android.gcm.server.Sender;
 
 
public class GCMServerSide {
 
	public void sendMessage(String regId, String comment ) throws IOException {
		Sender sender = new Sender("AIzaSyAv21r52ur6WNAyeG0PfKlF9rjKZzXDAYA");
		Message message = new Message.Builder().addData("insert", comment).build();
		List<String> list = new ArrayList<String>();
		list.add(regId);
		
		sender.send(message, list, 5);
	}
	
	// test code
	public void sendMessage() throws IOException {
		Sender sender = new Sender("AIzaSyAv21r52ur6WNAyeG0PfKlF9rjKZzXDAYA");
		String regId = "APA91bF4j7WZv3if_55P8Hf2WVqqEugF0ptxJ4wh1ncPxVtgNWPllzVWrtiyyCk9SWex6yPKW5Or7SCGq-HVfonwOsAbOx8a3RqsXh136jAFvEHjJLVtguSsbUNWTXT8kybJsIATOjJXpsl3rhJ584u682dL-R8rww";
		Message message = new Message.Builder().addData("insert", "언제 일정이 있습니다.").build();
		List<String> list = new ArrayList<String>();
		list.add(regId);
		 
		MulticastResult multiResult = sender.send(message, list, 5);
		if (multiResult != null) {
			List<Result> resultList = multiResult.getResults();
			for (Result result : resultList) {
				System.out.println(result.getMessageId());
			}
		}
	}
	 
	public static void main(String[] args) throws Exception {
		GCMServerSide s = new GCMServerSide();
		s.sendMessage();
	}
 
}
