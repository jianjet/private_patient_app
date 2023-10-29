import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Consent extends StatefulWidget {
  const Consent({Key? key}) : super(key: key);
  @override
  ConsentState createState() => ConsentState();
}

class ConsentState extends State<Consent> {

  bool _isChecked = false;

  Widget _consentDetails(){
    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.only(left: 5, right: 5),
        children: <Widget>[
          MarkdownBody(
            styleSheet: MarkdownStyleSheet(
              textAlign: WrapAlignment.spaceBetween
            ),
            data: 
'''
I hereby consent to engaging and using this Telehealth/Telemedicine platform with the qualified professional doctors who are registered with Malaysia Medical Council (MMC), holding a valid practising certificate. I understand that this platform may include the practice of health delivery, information sharing, transfer of health related data using interactive text or picture messages, video, audio or data communication in accordance with the Telemedicine Act 1997 Malaysia. 

I fully understand there are potential risks with this technology. I also understand that consultation, diagnosis of diseases/ailments and treatments cannot be performed via virtual consultation (text, audio, video or email) alone in view of its limitation.

I understand that I have the following rights with respect to the Telehealth/Telemedicine and their limitations are as follows:

1. I have the right to withhold/withdraw consent at any time without (i) affecting my right to future care and/or treatment or (ii) risking the loss of withdrawal of any program benefits to which I would otherwise be entitled.
2. The Personal Data Protection Act, 2010 that protects the confidentiality of my medical or personal health information apply to Telehealth/Telemedicine. As such, I understand that the information disclosed by me during the session in this platform is confidential and shall remain confidential at all times. I also understand that the dissemination of any personal identifable images or information from this interaction shall not occur without my consent. However, I authorise the release of my relevant medical or personal health information to the attending health care provider and/or its supervisor who may need this information for continuing care purposes.
3. I understand that there are risks and consequences from Telemedicine/Telehealth, including, but not limited to the possibility, that the transmission of my medical information could be disrupted or distorted by technical failure.
4. I understand that Telemedicine/Telehealth based services and care may not be as complete as face-to-face consultation. I also understand that if my doctor believes I would be better served by a face-to-face consultation, I would be advised as such.
5. I understand that Telemedicine/Telehealth is not appropriate for medical emergencies and that it is best sought by seeking care at the emergency department.
6. I understand that a physical examination will not take place during the session and this will limit the diagnosis and/or treatment of the disease/ailments. As such, I understand that this platform does not serve as a diagnostic or therapeutic service. I fully understand the risks and consequences of using the service of Telehealth/Telemedicine and I shall hold the service providers harmless against all claims actions, suits and/or proceedings arising from the use of this Telehealth/Telemedicine platform, save for negligence, willful default and fraud on the part of the service providers, their staff, employees and/or medical practitioners engaged through the Telemedicine/Telehealth platform.
7. I have read and understood the information provided above and understand the risks and consequences of Telehealth/Telemedicine and have had my questions answered regarding the procedure.

I hereby fully understand and agree to the above statement and consent to participate in this service under the conditions described in this document.
'''
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: FractionallySizedBox(
        widthFactor: 0.8,
        heightFactor: 0.5,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Telehealth/Telemedicine Consent', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                  Text('Last Updated: 26/4/2023', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue)),
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 85),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey
                )
              ),
              child: _consentDetails()
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      
                      const Text('I consent.'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: _isChecked ? (){
                          Navigator.pop(context);
                        } : null,
                        child: const Text('Next')
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed:() {
                          Navigator.pop(context);
                        }, 
                        child: const Text('Cancel')
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}