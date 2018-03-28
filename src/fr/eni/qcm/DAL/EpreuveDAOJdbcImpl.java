package fr.eni.qcm.DAL;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import fr.eni.qcm.BusinessError;
import fr.eni.qcm.BusinessException;
import fr.eni.qcm.BO.Epreuve;
import fr.eni.qcm.BO.Resultat;

public class EpreuveDAOJdbcImpl implements EpreuveDAO {

	private final String GET_USER_EPREUVE = "select * from EPREUVE where idUtilisateur = ?";
	private final String CREATE_USER_EPREUVE="insert into EPREUVE(dateDebutValidite, dateFinValidite, idTest, idUtilisateur) values (?,?,?,?)";
	
	// Construit un object Epreuve depuis un ResultSet
	private Epreuve buildEpreuve(ResultSet rs) throws SQLException {
		Epreuve epr = new Epreuve();
		
		epr.setIdEpreuve(rs.getInt(1));
		epr.setDebut(rs.getTimestamp(2).toInstant());
		epr.setFin(rs.getTimestamp(3).toInstant());
		epr.setTempsEcoule(rs.getInt(4));
		epr.setEtat(rs.getString(5));
		epr.setNoteObtenue(rs.getFloat(6));
		epr.setNiveauObtenu(rs.getString(7));
		epr.setIdTest(rs.getInt(8));
		epr.setIdUtilisateur(rs.getInt(9));
		
		return epr;
	}
	
	
	@Override
	public List<Epreuve> getUserEpreuve(int userID) throws BusinessException {
		List<Epreuve> epreuves = new ArrayList<>();
		
		try (Connection cnx = ConnectionProvider.getConnection()) {
			PreparedStatement pst = cnx.prepareStatement(GET_USER_EPREUVE);
			pst.setInt(1, userID);
			
			ResultSet rs = pst.executeQuery();
			
			while(rs.next()) {
				Epreuve epr = this.buildEpreuve(rs);
				epreuves.add(epr);				
			}			
		} 
		catch (SQLException e) {
			e.printStackTrace();
			throw new BusinessException(BusinessError.DATABASE_ERROR);
		}
		
		return epreuves;
	}


	@Override
	public Epreuve Create(Date dateDebut, Date dateFin, int idTest, int idUser) throws BusinessException {
		try(Connection cnx =ConnectionProvider.getConnection()){
			
			PreparedStatement pst= cnx.prepareStatement(CREATE_USER_EPREUVE);
			pst.setDate(1, (java.sql.Date) dateDebut);
			pst.setDate(2, (java.sql.Date) dateFin);
			pst.setInt(3,idTest);
			pst.setInt(4, idUser);
		}catch(SQLException e) {
			throw new BusinessException(BusinessError.DATABASE_ERROR);
		}
		
		
		return null;
	}



	@Override
	public List<Resultat> getResultatForTest(int testID) throws BusinessException {
		String query = "select * from EPREUVE as e left join UTILISATEUR as u "
					+ "on e.idUtilisateur = u.idUtilisateur "
					+ "where e.idTest = ?";
		
		List<Resultat> resultats = new ArrayList<>();
		
		try (Connection cnx = ConnectionProvider.getConnection()) {
			PreparedStatement pst = cnx.prepareStatement(query);
			pst.setInt(1, testID);
			
			ResultSet rs = pst.executeQuery();
			
			while(rs.next()) {
				Resultat res = new Resultat();
				
				res.setIdEpreuve(rs.getInt(1));
				res.setDebut(rs.getTimestamp(2).toInstant());
				res.setFin(rs.getTimestamp(3).toInstant());
				res.setTempsEcoule(rs.getInt(4));
				res.setEtat(rs.getString(5));
				res.setNoteObtenue(rs.getFloat(6));
				res.setNiveauObtenu(rs.getString(7));
				res.setIdTest(rs.getInt(8));
				res.setIdUtilisateur(rs.getInt(9));
				res.setNom(rs.getString(11));
				res.setPrenom(rs.getString(12));
				
				resultats.add(res);
			}			
		} 
		catch (SQLException e) {
			e.printStackTrace();
			throw new BusinessException(BusinessError.DATABASE_ERROR);
		}

		return resultats;
	}

}
