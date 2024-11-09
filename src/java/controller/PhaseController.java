/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.PhaseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.ProjectPhase;
import model.Group;
import service.BaseService;
import service.GroupService;

@WebServlet(name = "PhaseController",
        urlPatterns = {"/phaselist", "/phasedetail", "/projectphase"})
public class PhaseController extends HttpServlet {

    private PhaseDAO phaseDAO = new PhaseDAO();
    private GroupService groupService = new GroupService();
    private final BaseService baseService = new BaseService();

    private final String alloLink = "/WEB-INF/view/user/domainConfig/PhaseList.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        try {
            if (servletPath.contains("/phaselist")) {
                showPhaseList(request, response);
            } else if (servletPath.contains("/phasedetail")) {
                showPhaseDetail(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
        if (request.getParameter("page") != null) {
            List<ProjectPhase> list = (List<ProjectPhase>) request.getSession().getAttribute("alloList");
            String modalItemIDRaw = request.getParameter("modalItemID");
            if (modalItemIDRaw != null) {
                int modalItemID = Integer.parseInt(modalItemIDRaw);
                try {
                    request.getSession().setAttribute("modalItem", phaseDAO.getPhaseById(modalItemID));
                } catch (SQLException ex) {
                    throw new ServletException(ex);
                }
            }
            pagination(request, response, list, alloLink);
        } else {
            //showPhaseList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String action = request.getParameter("action");

        try {
            if (servletPath.contains("/phaselist")) {
                switch (action) {
                    case "search" ->
                        handleSearch(request, response);
                    case "add" ->
                        handleAdd(request, response);
                    case "changeStatus" ->
                        handleStatusChange(request, response);
                    case "delete" ->
                        handleDelete(request, response);
                }
            } else if (servletPath.contains("/phasedetail")) {
                if ("edit".equals(action)) {
                    handleEdit(request, response);
                }
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void showPhaseList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Integer dID;
        String dIdRaw = request.getParameter("domainId");//lay parameter  domainId
        if (dIdRaw == null) {
            dID = (Integer) session.getAttribute("domainId");
            if (dID == null) {
                throw new ServletException("Some thing went wrong, cannot find the domain id");
            }
        } else {
            dID = Integer.valueOf(dIdRaw);
            session.setAttribute("domainId", dID);
        }
        List<ProjectPhase> phases = phaseDAO.getProjectPhaseByDomainId(dID);
        request.setAttribute("phases", phases);
        request.getSession().setAttribute("alloList", phases);
        request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/PhaseList.jsp").forward(request, response); 
    }

    private void showPhaseDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            ProjectPhase phase = phaseDAO.getPhaseById(id);
            request.setAttribute("phase", phase);
            request.setAttribute("domains", groupService.getAllDomains());
            request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/PhaseDetails.jsp").forward(request, response);
        }
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String keyword = request.getParameter("keyword");
        Integer domainId = null;
        Boolean status = null;

        try {
            if (request.getParameter("domainId") != null && !request.getParameter("domainId").isEmpty()) {
                domainId = Integer.parseInt(request.getParameter("domainId"));
            }
            if (request.getParameter("status") != null && !request.getParameter("status").isEmpty()) {
                status = Boolean.parseBoolean(request.getParameter("status"));
            }
        } catch (NumberFormatException e) {
            // Handle parsing error
        }

        List<ProjectPhase> phases = phaseDAO.getAll();
        phases = phaseDAO.searchFilter(phases, domainId, status, keyword);

        request.setAttribute("phases", phases);
        request.setAttribute("domains", groupService.getAllDomains());
        request.getRequestDispatcher("/WEB-INF/view/user/domainConfig/PhaseList.jsp").forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        ProjectPhase phase = new ProjectPhase();
        populatePhaseFromRequest(phase, request);

        phaseDAO.insert(phase);
        response.sendRedirect(request.getContextPath() + "/phaselist");
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        ProjectPhase phase = phaseDAO.getPhaseById(id);
        populatePhaseFromRequest(phase, request);

        phaseDAO.updatePhase(phase);
        response.sendRedirect(request.getContextPath() + "/phaselist");
    }

    private void handleStatusChange(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));

        phaseDAO.updateStatus(id, newStatus);
        response.sendRedirect(request.getContextPath() + "/phaselist");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        phaseDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/phaselist");
    }

    private void populatePhaseFromRequest(ProjectPhase phase, HttpServletRequest request) {
        phase.setName(request.getParameter("name"));
        phase.setPriority(Integer.parseInt(request.getParameter("priority")));
        phase.setDetails(request.getParameter("details"));

        String finalPhase = request.getParameter("finalPhase");
        String status = request.getParameter("status");

        phase.setFinalPhase(finalPhase != null);
        phase.setStatus(status != null);

        phase.setCompleteRate(Integer.parseInt(request.getParameter("completeRate")));

        Group domain = new Group();
        domain.setId(Integer.parseInt(request.getParameter("domainId")));
        phase.setDomain(domain);
    }

    public void pagination(HttpServletRequest request, HttpServletResponse response, List<?> list, String link) throws ServletException, IOException {
        int page, numperpage = 12;
        int size = list.size();
        int num = (size % numperpage == 0 ? (size / numperpage) : (size / numperpage) + 1);//so trang
        if (num == 0) {
            num = 1;
        }
        String xpage = request.getParameter("page");
        if (xpage == null) {
            page = 1;
        } else {
            page = Integer.parseInt(xpage);
            if (page > num) {
                page = num;
            }
        }
        int start, end;
        start = (page - 1) * numperpage;
        end = Math.min(page * numperpage, size);
        request.setAttribute("page", page);
        request.setAttribute("num", num);
        request.getSession().setAttribute("numberPage", numperpage);
        request.setAttribute("tableData", baseService.getListByPage(list, start, end));
        request.getRequestDispatcher(link).forward(request, response);
    }
}
