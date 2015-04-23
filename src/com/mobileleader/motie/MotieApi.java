package com.mobileleader.motie;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Map;
import java.util.Scanner;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.catalina.connector.Request;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
 
@WebServlet("/motieApi")
public class MotieApi extends HttpServlet {
	private static final long serialVersionUID = 1L;
      
    public MotieApi() {
        super();       
    }
 
    @SuppressWarnings("deprecation")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
		@SuppressWarnings("resource")
		HttpClient httpclient = new DefaultHttpClient();
		
		String responseBody = "";
		String url = request.getParameter("url");
		HttpGet get = new HttpGet(url);
		
		try {
			HttpResponse execute = httpclient.execute(get);
			InputStream content = execute.getEntity().getContent();
			
			BufferedReader buffer = new BufferedReader( new InputStreamReader(content));
			
			String sTmp = "";
			while ((sTmp = buffer.readLine()) != null) {
				responseBody += sTmp;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
/*		responseBody = responseBody.replace("'", "\"");
		responseBody = GetPercentage(responseBody);
*/		
		
		PrintWriter out;
		out = response.getWriter();
		out.println(responseBody);
		 
		return;
	}
 
	@SuppressWarnings("deprecation")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 
		String requestUrl = request.getParameter("url");
		
		@SuppressWarnings("resource")
		HttpClient httpclient = new DefaultHttpClient();
		String responseBody = "";
	    HttpPost post;

	    StringBuilder stringBuilder = new StringBuilder(1000);
	    Scanner scanner = new Scanner(request.getInputStream());
	    while (scanner.hasNextLine()) {
	        stringBuilder.append(scanner.nextLine());
	        }
	            
	    post = new HttpPost(requestUrl);
	            
	    String Responsebody = stringBuilder.toString();
	            
	    post.setEntity(new StringEntity(Responsebody, ContentType.create("application/json")));
	    
	    ResponseHandler<String> responseHandler = new BasicResponseHandler();
	    responseBody = httpclient.execute(post, responseHandler);
	         	            
	    PrintWriter out;
	    out = response.getWriter();
	    out.println(responseBody);
	    
	    request.setAttribute("id", "ppusari");

	    return;	                    
	}

	@Override
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		@SuppressWarnings("resource")
		HttpClient httpclient = new DefaultHttpClient();
		String responseBody = "";

		String url = request.getParameter("url");

		try {
			HttpDelete httpDelete = new HttpDelete(url);
			ResponseHandler<String> handler = new BasicResponseHandler();
	        HttpResponse httpResponse = httpclient.execute(httpDelete);
	        HttpEntity entity = httpResponse.getEntity();
	        responseBody = EntityUtils.toString(entity);

		} catch (Exception e) {
			e.printStackTrace();
		}

		PrintWriter out;
		out = response.getWriter();
		out.println(responseBody);

		return;
	//	super.doDelete(request, response);
	}
 	
	public String GetPercentage(String str)
	{
		try {
			JSONObject json = new JSONObject(str);
 
			// 오브젝트 안에 오브젝트 뽑아오기
			JSONObject objJob = json.getJSONObject("Jobs");
				
			// 오브젝트 안에서 배열 뽑아오기
			JSONArray outputs = objJob.getJSONArray("Outputs");
			JSONObject obj = outputs.getJSONObject(0);				
			return obj.getString("Status");			
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return null;	 
	}
}
