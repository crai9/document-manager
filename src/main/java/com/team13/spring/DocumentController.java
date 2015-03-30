package com.team13.spring;

import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;

import com.team13.spring.db.DBManager;
import com.team13.spring.login.Encrypt;
import com.team13.spring.model.Document;
import com.team13.spring.model.User;

import org.json.JSONArray;
import org.json.JSONException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class DocumentController {
	
	public static Boolean hasRole(HttpServletRequest request, String role){
	String[] roles = (String[])request.getSession().getAttribute("roles");
	if(roles == null){
		return false;
	} else {
		if(!Arrays.asList(roles).contains(role)){
			return false;
		}
		return true;
	}
}

	@RequestMapping(value = {"/createDocument"}, method = RequestMethod.GET)
	public String createDocument(HttpServletRequest request, Model model){
		
		if(!hasRole(request, "ROLE_USER")){
			return "403";
		}
		int id = (Integer) request.getSession().getAttribute("id");
		model.addAttribute("you", DBManager.getUserById(id));
		
		return "createDocument";
	}
	
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	public String create(
			@RequestParam("title") String title, @RequestParam("description") String description,
			@RequestParam("authorName") String authorName, @RequestParam("revNo") int revNo, @RequestParam("file") String file,
			@RequestParam("dateCreated") String dateCreated, @RequestParam("status") String status,
			@RequestParam(value = "distributees", required = false) String distributeesJSON, HttpServletRequest request) throws JSONException{
		
		if(!hasRole(request, "ROLE_USER")){
			return "403";
		}
		
	    ArrayList<String> stringArray = new ArrayList<String>();
	    JSONArray jsonArray = new JSONArray(distributeesJSON);

	    for (int i = 0; i < jsonArray.length(); i++) {
	        stringArray.add(jsonArray.getString(i));
	    }

		long documentId = DBManager.createDocument(title, description, authorName);
		DBManager.addRevision(revNo, file, documentId, dateCreated, status);
		
		for(String dist : stringArray){
			int userId = Integer.parseInt(dist);
			DBManager.addDistributee(userId, (int) documentId);
			System.out.println(userId);
		}
		
		return "redirect:/viewDoc/" + documentId;
	}
	
	@RequestMapping(value = {"/test"})
	public String test(){

		return "test";
	}
	
	@RequestMapping(value = {"/documents/page/{pageNo}"}, method = RequestMethod.GET)
	public String documents(Model model, HttpServletRequest request, @PathVariable int pageNo){
		if(!hasRole(request, "ROLE_USER")){
			return "403";
		}
		
		String s = null;
		
		double total = DBManager.countDocuments();
		double perPage = 10;
		int pages = (int) Math.ceil(total / perPage);
		int nextPage, prevPage;
		
		if(pages > 1){
			if(pageNo <= 1){
				pageNo = 1;
				prevPage = pageNo;
				nextPage = pageNo + 1;
			} else if(pageNo >= pages) {
				pageNo = pages;
				nextPage = pageNo;
				prevPage = pageNo - 1;
			} else {
				nextPage = pageNo + 1;
				prevPage = pageNo - 1;
			}	
		} else {
			nextPage = 0;
			prevPage = 0;
		}

		
		int start = (int) ((pageNo - 1) * (perPage));
		
		System.out.println("There will be " + pages + " pages.");
		System.out.println("You are on page:  " + pageNo);
		
		model.addAttribute("documents", DBManager.allDocumentsPaged(s, perPage, start));
		model.addAttribute("totalPages", (int) pages);
		model.addAttribute("pageNo", pageNo);
		model.addAttribute("nextPage", nextPage);
		model.addAttribute("prevPage", prevPage);
		
		return "viewDocuments";
	}
	
	@RequestMapping(value = {"/documents/search/{search}/page/{pageNo}"}, method = RequestMethod.GET)
	public String documentsSearch(Model model, HttpServletRequest request, @PathVariable int pageNo, @PathVariable String search){
		if(!hasRole(request, "ROLE_USER")){
			return "403";
		}
		
		String s = search;
		
		double total = DBManager.countDocuments(search);
		double perPage = 10;
		int pages = (int) Math.ceil(total / perPage);
		int nextPage, prevPage;
		
		if(pages > 1){
			if(pageNo <= 1){
				pageNo = 1;
				prevPage = pageNo;
				nextPage = pageNo + 1;
			} else if(pageNo >= pages) {
				pageNo = pages;
				nextPage = pageNo;
				prevPage = pageNo - 1;
			} else {
				nextPage = pageNo + 1;
				prevPage = pageNo - 1;
			}	
		} else {
			nextPage = 0;
			prevPage = 0;
		}

		
		int start = (int) ((pageNo - 1) * (perPage));
		
		System.out.println("There will be " + pages + " pages.");
		System.out.println("You are on page:  " + pageNo);
		
		model.addAttribute("documents", DBManager.allDocumentsPaged(s, perPage, start));
		model.addAttribute("totalPages", (int) pages);
		model.addAttribute("pageNo", pageNo);
		model.addAttribute("nextPage", nextPage);
		model.addAttribute("prevPage", prevPage);
		
		return "viewDocuments";
	}
	
	@RequestMapping(value = {"/viewDoc/{id}"}, method = RequestMethod.GET)
	public String viewDocs(Model model, HttpServletRequest request, @PathVariable int id){
		if(!hasRole(request, "ROLE_USER")){
			return "403";
		}
		
		model.addAttribute("document", DBManager.getDocumentById(id));
		return "viewDoc";
	}
	
	//Delete User
	@RequestMapping(value = "/document/delete/{id}")
	public String deleteDocument(HttpServletRequest request, @PathVariable int id){
		
		if(!hasRole(request, "ROLE_USER")){
			return "403";
		}
		
		DBManager.deleteDocumentById(id);
		
		System.out.println("Removed row with id " + id);
		
		return "redirect:/dashboard";
	}
	
	//Revise Document
	@RequestMapping(value = {"/reviseDocument/{id}"}, method = RequestMethod.GET)
	public String reviseDocument(Model model, HttpServletRequest request, @PathVariable int id){
		if(!hasRole(request, "ROLE_USER")){
			return "403";
		}
		
		Document revisionNo = DBManager.getDocumentById(id);
		int number = revisionNo.getRevisionNo();
		revisionNo.setRevisionNo(number + 1);
		
		model.addAttribute("revision", revisionNo);
		model.addAttribute("revisionNo", number + 1);
		
		return "revise";
		
	}
	
	@RequestMapping(value = "/revise", method = RequestMethod.POST)
	public String revise(
			@RequestParam("documentId") long documentId,
			@RequestParam("revNo") int revNo, @RequestParam("file") String file,
			@RequestParam("dateCreated") String dateCreated, @RequestParam("status") String status,
			HttpServletRequest request){
		
		if(!hasRole(request, "ROLE_USER")){
			return "403";
		}
		
		DBManager.addRevision(revNo, file, documentId, dateCreated, status);
		
		return "redirect:/viewDoc/" + documentId;
	}
	
	
}
