• Instruction to run the backend node server
cd into backend (cd backend)
run npm i if error run npm i --force
run npx prisma generate
run npx prisma migrate dev --name test

backend setup complete

• Instruction to run the flutter app
cd into forntend(cd frontend)
flutter run
if error=> first check if env is ok by running flutter doctor
then flutter clean
flutter pub get
flutter run

UserData is stored in PostgreSQl and user notes are stored in Firestore

The notes page contains notes of the user which is managed by firestore

All the necessary CRUD methods are contained within the services/firestore_service.dart file

login might not work cause it has the sha1 fingerprint of my machine
