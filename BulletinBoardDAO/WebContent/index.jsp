<%@page pageEncoding="UTF-8"%>
<%@ include file="header.jspf" %>	

<%
//我们在这里嵌入循环逻辑
String method = request.getParameter("method");
Iterator<Post> it = null;
if(method == null){
	List<Post> list = DAOFactory.getIPostInstance().getPosts();
	it = list.iterator();
}else if(user.getUserid() != 0){
	if(method.equals("search")){
		String kw = request.getParameter("keywords");
		if(kw != null && kw.length() > 0){
			it = DAOFactory.getIPostInstance().findByKeyword(kw).iterator();
		}else{
			session.setAttribute("flash_msg", "搜索需要参数啊喂◡ ヽ(`Д´)ﾉ ┻━┻");
		}
	}
}else{
	session.setAttribute("flash_msg", "登陆后才能操作呢QAQ");
}
%>
		<!-- 内容区域 -->
		<div class="container" style="padding-top:20px">
		
		<!---->
					<%if(session.getAttribute("flash_msg") != null){ %>
					<div class="alert alert-danger alert-dismissable">
			            <button type="button" class="close" data-dismiss="alert"
			                    aria-hidden="true">
			                &times;
			            </button>
			            <%=session.getAttribute("flash_msg") %>
			        </div>
			        <%
			        	session.removeAttribute("flash_msg");
					} %>
		
			<div class="row">
				<div class="col-md-4">
					<div class="card mb-3">
						<div class="card-body">
							<form class="form-inline" action="index.jsp">
								<input class="sr-only" type="text" name="method" value="search">
							    <input class="form-control mr-sm-2" type="text" placeholder="关心的话题" aria-label="Search" name="keywords">
							    <button class="btn btn-outline-success my-1 my-sm-2 mb-2" type="submit">搜索</button>
							</form>
							<div class="mb-3"></div>
							<a href="post.jsp?method=new" class="btn btn-primary">新留言</a>
							<!--
							<a href="index.jsp?method=mypost" class="btn btn-primary">我所发布</a>
							  -->
						</div>
					</div>
				</div>
				<!--col4-->

				<div class="col-md-8">
					
					<!-- 怎样将循环嵌入呢? -->
					<%
					while(it != null && it.hasNext()){
						Post p = it.next();
					%>
				        	<div class="card mb-3">
								<div class="card-body">
									    <div class="d-flex w-100 justify-content-between">
									      <h5 class="mb-3"><%=p.getTitle() %></h5>
									      <small><%=p.getPostdate() %></small>
									    </div>
									    <p class="mb-3"><%=p.getPost() %></p>
									    <div class="d-flex w-100 justify-content-between">
									      <span><small>由<em><%=p.getUsername() %></em>发表</small></span>
									      <span>
									      <%if(user.getUserid() == p.getUserid()){ %>
									      <small><a href="post.jsp?method=edit&postid=<%=p.getPostid()%>">编辑</a></small>
									      <small><a href="post.jsp?method=delete&postid=<%=p.getPostid()%>">删除</a></small>
									      <%}%>
									      </span>

									    </div>
								</div>
							</div>
				        	
				        	<% 
					}
				        	%>
				        	
					<div class="mb-5"></div>
				</div>
			</div>
			</div>
		<%@ include file="footer.jspf" %>