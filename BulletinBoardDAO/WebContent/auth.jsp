<%@ include file="header.jspf" %>
<%@page pageEncoding="UTF-8"%>
<jsp:setProperty property="*" name="user"/>
<%
String method = request.getParameter("method");
if(method == null){
	response.sendRedirect("auth.jsp?method=login");
	return;
}
if(method.equals("login")){
	if(user.isValid1()){
		user = DAOFactory.getIUserInstance().doLogin(user);
		if(user != null){
			session.setAttribute("user", user);
			session.setAttribute("flash_msg", "欢迎你!");
			response.sendRedirect("index.jsp");
			return;
		}else{
			session.setAttribute("flash_msg", "用户名和密码不匹配!");
			session.removeAttribute("user");
		}
	}
}else if(method.equals("regist")){
	if(user.isValid2()){
		if(DAOFactory.getIUserInstance().doRegist(user)){
			session.setAttribute("flash_msg", "注册成功!");
			response.sendRedirect("auth.jsp?method=login");
			session.removeAttribute("user");
			return;
		}else{
			session.setAttribute("flash_msg", "注册失败!");
			session.removeAttribute("user");
		}
	}else if(user.getUsername().length() > 0 || user.getPassword().length() > 0 || user.getPassword_confirm().length() > 0){
		session.setAttribute("flash_msg", "信息填写有误!");
		session.removeAttribute("user");
	}
}else if(method.equals("logout")){
	session.removeAttribute("user");
	response.sendRedirect("index.jsp");
	return;
}
%>

		<!-- 内容区域 -->

		<body class="login-body">
			<view style="padding:50px"></view>
			<view class="text-center">
				<form class="form-signin" method="post">
					<img class="mb-4"
						src="https://cdn.wlfj.fun/wp-content/uploads/2020/03/cropped-unnamed-192x192.jpg"
						alt="" width="72" height="72">
					<h1 class="h3 mb-3 font-weight-normal">实名上网,人人有责.</h1>
					<!-- 在这里添加告示 但是注意 如果使用重定向 则这里不应该将其删除 否则会出现问题 -->
					
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
					<input type="text" name="method" value="login" class="sr-only">
					<label for="inputUserName" class="sr-only">用户名</label>
					<input type="text" id="inputUserName" class="form-control mb-3" placeholder="用户名" name="username" required autofocus>
					<label for="inputPassword" class="sr-only">密码</label>
					<input type="password" id="inputPassword" class="form-control mb-3" placeholder="密码" name="password" required>
					<%if(method.equals("regist")){//需要注册 %>
					<label for="inputPassword2" class="sr-only">确认密码</label>
					<input type="password" id="inputPassword2" class="form-control mb-3" placeholder="确认密码" name="password_confirm" required>
					<%} %>
					<%if(method.equals("login")){ %>
					<p></p>
					<p class="text-right">没有账号?<a href="auth.jsp?method=regist">点我注册</a></p>
					<%} %>
					</div>
					<button class="btn btn-lg btn-primary btn-block" type="submit"><%=(method.equals("regist") ? "注册" : "登陆")%></button>
					<div class="mb-5">
				</form>
			</view>

		</body>

<%@ include file="footer.jspf" %>