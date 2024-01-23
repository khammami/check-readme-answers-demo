#!/bin/bash

total_score=0

# Function to check and grade a single question
check_question() {
  local question_text="$1"
  local correct_answer_pattern="$2"
  local student_response="$3"

  student_q_response=$(grep -A 5 ".*$question_text" <<< "$student_response")

  # Check for empty response
  if [[ -z "$student_q_response" ]]; then
    echo "Question $question_text: Aucune réponse"
    score=0
    return
  fi

  # Count correctly checked answers
  correct_count=$(grep -i "\\[X\] $correct_answer_pattern" <<< "$student_q_response" | wc -l)

  # Count all checked answers (including extras)
  checked_count=$(grep -i "\[X\]" <<< "$student_q_response" | wc -l)

  # Calculate score (1 for correct, -1 for extra)
  score=$((correct_count - (checked_count - correct_count)))
  score=$((score < 0 ? 0 : score))  # Apply conditional check for non-negative score

  # # Calculate score (1 for correct, 0 for incorrect)
  # score=$((correct_count))

  total_score=$((total_score + score))

  echo "Question: $question_text"
  echo "Correct answer(s): $correct_answer_pattern"
  echo "Student response: $student_q_response"
  echo "Score: $score"
  echo ""
}

# Define questions and answers
# questions=(
#   "Quelles modifications sont apportées lorsque vous ajoutez une deuxième activité à votre application en choisissant"
#   "Que se passe-t-il si vous supprimez les éléments \`android:parentActivityName\` et \`<meta-data>\` de la deuxième déclaration d'activité du fichier \`AndroidManifest.xml\`\?"
# )

# answers=(
#   "La deuxième activité est ajoutée en tant que classe Java. Vous devez toujours ajouter le fichier de mise en page (layout) XML."
#   "Le deuxième fichier de mise en page (layout) XML d'activité est supprimé."
# )

IFS=$'\n'
readarray -t questions < questions.txt
readarray -t answers < answers.txt

# Read the student responses from the README.md file
student_responses=$(grep -A 5 ".* Choisissez-en un" README.md)

# Loop through each question and grade
for i in "${!questions[@]}"; do
  check_question "${questions[$i]}" "${answers[$i]}" "$student_responses"
done

echo "Total Score: $total_score"
echo "Total Ques.: ${#questions[@]}"

exit 0
