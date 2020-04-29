<%@ include file="header.jspf" %>
<%@page pageEncoding="UTF-8"%>
<%String method = request.getParameter("method");%>
<!-- 如果编辑的参数全有,则进行编辑操作 -->
<jsp:useBean id="post" class="fun.wlfj.vo.Post" scope="page"></jsp:useBean>
<jsp:setProperty property="*" name="post"/>
<%
if(method == null){
	request.setAttribute("flash_msg", "非法请求QAQ");
	response.sendRedirect("index.jsp");
	return;
}
if(method.equals("edit") || method.equals("new")){
	
	//检查一下是否需要登陆
	if(user.getUserid() == 0){
		session.setAttribute("flash_msg", "请先在右上角登陆/注册后再操作:P");
		response.sendRedirect("index.jsp");
		return;
	}
}
if(method.equals("edit")){
	if(post.isValid() && post.getUserid() == user.getUserid()){
		//创建 并使用flash_msg
		if(DAOFactory.getIPostInstance().doModify(post)){
			//创建成功!
			session.setAttribute("flash_msg", "编辑成功!");
		}else{
			session.setAttribute("flash_msg", "编辑失败!");
		}
		response.sendRedirect("index.jsp");
		return;
	}else{
		post = DAOFactory.getIPostInstance().getPostByID(post);
	}
}else if(method.equals("new")){
	if(post.isValid() && post.getUserid() == user.getUserid()){//这里有隐患 还好修复了
		if(DAOFactory.getIPostInstance().doPost(post)){
			session.setAttribute("flash_msg", "新消息发表成功!");
		}else{
			session.setAttribute("flash_msg", "新消息发表失败!");
		}
		response.sendRedirect("index.jsp");
		return;
	}
}else if(method.equals("delete")){
	post.setUserid(user.getUserid());
	if(DAOFactory.getIPostInstance().doDelete(post)){
		session.setAttribute("flash_msg", "删除成功!");
	}else{
		session.setAttribute("flash_msg", "删除失败!");
	}
	response.sendRedirect("index.jsp");
	return;
}%>
<!-- end -->

		<!-- 内容区域 -->
		<div class="container" style="padding-top:20px">
							<%if(session.getAttribute("flash_msg") != null){ %>
					<div class="alert alert-danger alert-dismissable">
			            <button type="button" class="close" data-dismiss="alert"
			                    aria-hidden="true">
			                &times;
			            </button>
			            <%=session.getAttribute("flash_msg") %>
			        </div>
			        <%
			        if(response.getHeader("Location") == null){//通过头来判断是否需要删除消息
			        	session.removeAttribute("flash_msg");
			        }
					} %>
			<div class="row">
				<div class="col-md-8 offset-md-2">
					<div class="card mb-3">
					  <div class="card-header">
					    <%=(method.equals("new")?"发布新留言":"编辑留言")%>
					  </div>
					  <div class="card-body">
					    <form method="post">
					    <input type="text" name="method" class="sr-only" value="<%=method%>">
					    <input type="text" name="userid" class="sr-only" value="<%=user.getUserid()%>">
					    <%
					    Post p = null;
					    
					    %>
						  <div class="form-group">
						    <label for="inputTitle">标题</label>
						    <input type="text" class="form-control" id="inputTitle" name="title" value="<%=method.equals("edit")? post.getTitle() : ""  %>" required>
						  </div>
						  <div class="form-group">
						    <label for="inputText">正文</label>
						    <textarea class="form-control" id="inputText" rows="6" name="post"  required><%=method.equals("edit")? post.getPost() : ""  %></textarea>
						  </div>
						  <hr>
						  <button type="submit" class="btn btn-primary">发布</button>
						</form>
					  </div>
					</div>
				</div>

			</div>
			</div>
		<%@ include file="footer.jspf" %>