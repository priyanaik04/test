import streamlit as st
import nltk
import spacy
nltk.download('stopwords')
spacy.load('en_core_web_sm')

import pandas as pd
import base64, random
import time, datetime
from pyresparser import ResumeParser
from pdfminer.layout import LAParams, LTTextBox
from pdfminer.pdfpage import PDFPage
from pdfminer.pdfinterp import PDFResourceManager
from pdfminer.pdfinterp import PDFPageInterpreter
from pdfminer.converter import TextConverter
import io, random
from streamlit_tags import st_tags
from PIL import Image
import sys
from pyresparser import ResumeParser

def pdf_reader(file):
    resource_manager = PDFResourceManager()
    fake_file_handle = io.StringIO()
    converter = TextConverter(resource_manager, fake_file_handle, laparams=LAParams())
    page_interpreter = PDFPageInterpreter(resource_manager, converter)
    with open(file, 'rb') as fh:
        for page in PDFPage.get_pages(fh,
                                      caching=True,
                                      check_extractable=True):
            page_interpreter.process_page(page)
            print(page)
        text = fake_file_handle.getvalue()

    # close open handles
    converter.close()
    fake_file_handle.close()
    return text

def parse_resume(resume_file_path):
    print(resume_file_path)
    try:
        resume_data = ResumeParser(resume_file_path).get_extracted_data()

        if resume_data:
            print("Extracted Information from Resume:")
            for key, value in resume_data.items():
                print(f"**{key}:** {value}")
          
            return resume_data
        else:
            print("Failed to extract information from the resume.")
            return None
    except Exception as e:
        print(f"Error parsing resume: {e}")
        return None

def display_skills_recommendation(resume_data):
   
   if resume_data:
        ds_keyword = ['tensorflow', 'keras', 'pytorch', 'machine learning', 'deep Learning', 'flask', 'streamlit']
        web_keyword = ['react', 'django', 'node jS', 'react js', 'php', 'laravel', 'magento', 'wordpress', 'javascript', 'angular js', 'c#', 'flask']
        android_keyword = ['android', 'android development', 'flutter', 'kotlin', 'xml', 'kivy']
        ios_keyword = ['ios', 'ios development', 'swift', 'cocoa', 'cocoa touch', 'xcode']
        uiux_keyword = ['ux', 'adobe xd', 'figma', 'zeplin', 'balsamiq', 'ui', 'prototyping', 'wireframes', 'storyframes', 'adobe photoshop', 'photoshop', 'editing', 'adobe illustrator', 'illustrator', 'adobe after effects', 'after effects', 'adobe premier pro', 'premier pro', 'adobe indesign', 'indesign', 'wireframe', 'solid', 'grasp', 'user research', 'user experience']
        recommended_skills = []
        reco_field = ''
        rec_course = ''

        ## Courses recommendation
        for i in resume_data['skills']:
            ## Data science recommendation
            if i.lower() in ds_keyword:
                print(i.lower())
                reco_field = 'Data Science'
                st.success("** Our analysis says you are looking for Data Science Jobs.**")
                recommended_skills = ['Data Visualization', 'Predictive Analysis', 'Statistical Modeling', 'Data Mining', 'Clustering & Classification', 'Data Analytics', 'Quantitative Analysis', 'Web Scraping', 'ML Algorithms', 'Keras', 'Pytorch', 'Probability', 'Scikit-learn', 'Tensorflow', "Flask", 'Streamlit']
                recommended_keywords = st_tags(label='### Recommended skills for you.',
                                                   text='Recommended skills generated from System',
                                                   value=recommended_skills, key='2')

                break
        
         ## Web development recommendation
            elif i.lower() in web_keyword:
                print(i.lower())
                reco_field = 'Web Development'
                st.success("** Our analysis says you are looking for Web Development Jobs **")
                recommended_skills = ['React', 'Django', 'Node JS', 'React JS', 'php', 'laravel', 'Magento', 'wordpress', 'Javascript', 'Angular JS', 'c#', 'Flask', 'SDK']
                recommended_keywords = st_tags(label='### Recommended skills for you.',
                                                   text='Recommended skills generated from System',
                                                   value=recommended_skills, key='3')

                break

            ## Android App Development
            elif i.lower() in android_keyword:
                print(i.lower())
                reco_field = 'Android Development'
                st.success("** Our analysis says you are looking for Android App Development Jobs **")
                recommended_skills = ['Android', 'Android development', 'Flutter', 'Kotlin', 'XML', 'Java', 'Kivy', 'GIT', 'SDK', 'SQLite']
                recommended_keywords = st_tags(label='### Recommended skills for you.',
                                                   text='Recommended skills generated from System',
                                                   value=recommended_skills, key='4')

                break

            ## IOS App Development
            elif i.lower() in ios_keyword:
                print(i.lower())
                reco_field = 'IOS Development'
                st.success("** Our analysis says you are looking for IOS App Development Jobs **")
                recommended_skills = ['IOS', 'IOS Development', 'Swift', 'Cocoa', 'Cocoa Touch', 'Xcode', 'Objective-C', 'SQLite', 'Plist', 'StoreKit', "UI-Kit", 'AV Foundation', 'Auto-Layout']
                recommended_keywords = st_tags(label='### Recommended skills for you.',
                                                   text='Recommended skills generated from System',
                                                   value=recommended_skills, key='5')

                break

            ## Ui-UX Recommendation
            elif i.lower() in uiux_keyword:
                print(i.lower())
                reco_field = 'UI-UX Development'
                st.success("** Our analysis says you are looking for UI-UX Development Jobs **")
                recommended_skills = ['UI', 'User Experience', 'Adobe XD', 'Figma', 'Zeplin', 'Balsamiq', 'Prototyping', 'Wireframes', 'Storyframes', 'Adobe Photoshop', 'Editing', 'Illustrator', 'After Effects', 'Premier Pro', 'Indesign', 'Wireframe', 'Solid', 'Grasp', 'User Research']
                recommended_keywords = st_tags(label='### Recommended skills for you.',
                                                   text='Recommended skills generated from System',
                                                   value=recommended_skills, key='6')

                break
        return recommended_skills

def ratings(resume_data,resume_file_path):
    # skills=resume_data['skills']
    # skills_length=len(skills)
    # resume_text= pdf_reader(resume_file_path)
    # resume_score = 0
    # if 'Objective' in resume_text:
    #         resume_score = resume_score + 20
            

    # if 'Declaration' in resume_text:
    #         resume_score = resume_score + 20
            

    # if 'Hobbies' or 'Interests' in resume_text:
    #         resume_score = resume_score + 20
        
    # if 'Achievements' in resume_text:
    #         resume_score = resume_score + 20
        

    # if 'Projects' in resume_text:
    #         resume_score = resume_score + 20
  weights = {
  'Objective': 10,
  'Declaration': 5,
  'Projects': 15,
  'Achievements': 15,
  'skills': 2  # Weight each skill with a value of 2
   }
  resume_text = pdf_reader(resume_file_path)
  total_weight = sum(weights.values())  # Calculate sum of all weights

  # Check for keywords and assign weighted score
  resume_score = 0
  for keyword, weight in weights.items():
    if keyword in resume_text:
      resume_score += weight

  # Add score based on skills (consider weighting based on relevance)
  skills_length = len(resume_data.get('skills', []))  # Handle missing skills
  resume_score += skills_length * weights.get('skills', 0)  # Weight skills if defined

  # Normalize score (optional):
  # normalized_score = resume_score / total_weight  # Scale score between 0 and 1

  return resume_score




    



if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python resume_parser.py <resume_file_path>")
        sys.exit(1)

    resume_file_path = sys.argv[1]
    resume_data = parse_resume(resume_file_path)  # Parse resume to get resume data






