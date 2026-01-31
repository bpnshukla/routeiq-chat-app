import { useState } from 'react';

interface JsonInputHelperProps {
  onInsert: (json: string) => void;
}

const JsonInputHelper = ({ onInsert }: JsonInputHelperProps) => {
  const [isOpen, setIsOpen] = useState(false);
  const [jsonTemplate] = useState(`{
  "origin": "AUH",
  "candidateDestinations": ["LHR", "JFK", "DXB"],
  "month": 6,
  "frequencyPerWeek": 7,
  "candidateFleets": ["A380", "B777", "B787"]
}`);

  const handleInsert = () => {
    onInsert(jsonTemplate);
    setIsOpen(false);
  };

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="text-sm text-blue-600 hover:text-blue-700 underline"
      >
        📋 Use JSON Template
      </button>
      
      {isOpen && (
        <div className="absolute bottom-full mb-2 left-0 w-96 bg-white border border-gray-300 rounded-lg shadow-lg p-4 z-10">
          <div className="flex justify-between items-center mb-2">
            <h3 className="font-semibold text-gray-900">JSON Input Template</h3>
            <button
              onClick={() => setIsOpen(false)}
              className="text-gray-500 hover:text-gray-700"
            >
              ✕
            </button>
          </div>
          <pre className="bg-gray-50 p-3 rounded text-xs overflow-x-auto mb-3">
            {jsonTemplate}
          </pre>
          <button
            onClick={handleInsert}
            className="w-full px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            Insert Template
          </button>
        </div>
      )}
    </div>
  );
};

export default JsonInputHelper;


