package FX_Challenges_Repository;

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.Period;
import java.util.Calendar;
import java.util.Date;
// --- <<IS-END-IMPORTS>> ---

public final class utils

{
	// ---( internal utility methods )---

	final static utils _instance = new utils();

	static utils _newInstance() { return new utils(); }

	static utils _cast(Object o) { return (utils)o; }

	// ---( server methods )---




	public static final void calculateAge (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(calculateAge)>> ---
		// @sigtype java 3.5
		// [i] field:0:required birthDate
		// [o] field:0:required years
		IDataCursor pipelineCursor = pipeline.getCursor();
		String	dateOfBirth = IDataUtil.getString( pipelineCursor, "birthDate" );
		try {
			Date _dob=new SimpleDateFormat("dd-MMM-yyyy").parse(dateOfBirth); 
			Calendar now = Calendar.getInstance();
			Calendar dob = Calendar.getInstance();
			dob.setTime(_dob);
						
		    LocalDate birthDate = LocalDate.of(dob.get(Calendar.YEAR), dob.get(Calendar.MONTH)+1, dob.get(Calendar.DATE));
			LocalDate todays=LocalDate.of(now.get(Calendar.YEAR), now.get(Calendar.MONTH)+1, now.get(Calendar.DATE));
			int years=Period.between(birthDate, todays).getYears();
			
			// pipeline
			IDataUtil.put( pipelineCursor, "years", Integer.toString(years) );
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			IDataUtil.put( pipelineCursor, "error", e.getMessage() );
		}
		pipelineCursor.destroy();
			
		// --- <<IS-END>> ---

                
	}
}

