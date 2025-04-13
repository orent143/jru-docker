from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from config import SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def create_access_token(data: dict):
    """
    Create a JWT token with an expiration time.
    """
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def verify_password(plain_password, hashed_password):
    """
    Verify if the plain password matches the hashed password.
    """
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    """
    Hash a plain password.
    """
    return pwd_context.hash(password)

def decode_access_token(token: str):
    """
    Decode the JWT token and verify its authenticity.
    """
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload  
    except JWTError:
        raise Exception("Invalid token or expired token")

def get_current_user(token: str = Depends(oauth2_scheme)):
    """
    Extract the current user from the token.
    """
    try:
        payload = decode_access_token(token)
        return payload  
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
